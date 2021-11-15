import 'package:vismaya/config.dart';
import 'package:vismaya/models/address.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/models/cart_item.dart';
import 'package:vismaya/models/cart_total.dart';
import 'package:vismaya/models/delivery_times/selected_delivery_time.dart';
import 'package:vismaya/models/payment.dart';
import 'package:vismaya/models/payment_method.dart';
import 'package:vismaya/models/shipping_billing_request.dart';
import 'package:vismaya/models/shipping_method.dart';
import 'package:vismaya/repositories/local/local_repository.dart';
import 'package:vismaya/repositories/local/models/product_variant_model.dart';
import 'package:vismaya/repositories/local/pref_manager.dart';
import 'package:vismaya/repositories/remote/api_response.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

class BasketUsecase {
  static Future<ApiResponse<CartItem>> addItemToCart(String sku) async {
    final cartItem = CartItem(sku: sku, qty: 1);
    if (config.quoteId.isEmpty || !config.cart.isActive) {
      final response = await RemoteRepository().createCart();
      config.setQuoteId(response.data);
      config.cart.isActive = true;
    }
    cartItem.quoteId = config.quoteId;
    return await RemoteRepository().addItemToCart(cartItem);
  }

  static Future<ApiResponse<CartItem>> updateItemInCart(
      String sku, int qty) async {
    final _cartItem = config.cart.getCartItemBySku(sku);
    final cartItem =
        CartItem(itemId: _cartItem.itemId, qty: qty, quoteId: config.quoteId);
    return await RemoteRepository().updateItemToCart(cartItem);
  }

  static deleteItemFromCart(String sku) async {
    final _cartItem = config.cart.getCartItemBySku(sku);
    return await RemoteRepository().deleteItemFromCart(_cartItem.itemId);
  }

  static deleteItemFromCartByItemId(int itemId) =>
      RemoteRepository().deleteItemFromCart(itemId);

  static Future<ApiResponse<Cart>> getCart() async {
    try {
      //Check if migrate guest cart
      final guestQuoteId = prefManager.guestQuoteId;
      final hasGuestQuoteId = guestQuoteId.isNotEmpty;
      if (!config.isGuest && hasGuestQuoteId) {
        //Customer just logged in with guest cart already
        final customer = prefManager.customerInfo;
        await RemoteRepository().migrateGuestCart(guestQuoteId, customer);
        prefManager.setGuestQuoteId("");
      }
    } on Failure catch (e) {}
    return RemoteRepository().getCart();
  }

  static Future<ApiResponse<Cart>> getCartWithDetails() async {
    final response = await RemoteRepository().getCart();
    final cart = response.data;
    for (final item in cart.items) {
      final _productVariantModel =
          await localRepository.getProductVariantModel(item.sku);
      String brand = "";
      String packSize = "";
      if (_productVariantModel != null) {
        brand = config.getBrandName(_productVariantModel.brandValue);
        packSize = config.getPackSize(_productVariantModel.sizeValue);
      } else {
        final productResponse =
            await RemoteRepository().getProductVariantBySku(item.sku);
        final variant = productResponse.data;
        final _variant = ProductVariantModel(
            item.sku, variant.brandValue, variant.sizeValue);
        await localRepository.insert(_variant);
        brand = variant.getBrand();
        packSize = variant.getSize();
      }
      item.brand = brand;
      item.size = packSize;
    }
    //Assign shipping and billing address
    final address = cart.shippingAddress;
    if (!config.isGuest && address.isEmpty()) {
      final customerInfoResponse = await RemoteRepository().getCustomerInfo();
      final customerInfo = customerInfoResponse.data;
      await prefManager.setCustomerInfo(customerInfo);
      if (customerInfo.addresses.isNotEmpty) {
        final email = customerInfo.email;
        final defaultShippingAddress = customerInfo.addresses.firstWhere(
            (e) => e.defaultShipping,
            orElse: () => Address(email: email));
        final defaultBillingAddress = customerInfo.addresses.firstWhere(
            (e) => e.defaultBilling,
            orElse: () => defaultShippingAddress.clone());
        defaultShippingAddress.email = email;
        defaultBillingAddress.email = email;
        cart.shippingAddress = defaultShippingAddress.clone();
        cart.billingAddress = defaultBillingAddress.clone();
      }
    }

    return ApiResponse(data: cart);
  }

  static Future<ApiResponse<CartTotal>> getCartTotal() =>
      RemoteRepository().getCartTotal();

  static Future<ApiResponse<List<ShippingMethod>>> estimateShippingMethods(
          Address shippingAddress) =>
      RemoteRepository().estimateShippingMethods(shippingAddress);

  static Future<ApiResponse<Payment>> setShippingAndBillingInfo(
          ShippingBillingRequest request) =>
      RemoteRepository().setShippingAndBillingInfo(request);

  static Future<ApiResponse<bool>> setDeliveryTimes(
          SelectedDeliveryTime selectedDeliveryTime) =>
      RemoteRepository().setDeliveryTimes(selectedDeliveryTime);

  static Future<ApiResponse<String>> orderNow(PaymentMethod paymentMethod) =>
      RemoteRepository().orderNow(paymentMethod);
}
