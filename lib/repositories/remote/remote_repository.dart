import 'package:vismaya/models/address.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/models/cart_item.dart';
import 'package:vismaya/models/cart_total.dart';
import 'package:vismaya/models/category.dart';
import 'package:vismaya/models/component.dart';
import 'package:vismaya/models/customer.dart';
import 'package:vismaya/models/delivery_times/delivery_times.dart';
import 'package:vismaya/models/delivery_times/selected_delivery_time.dart';
import 'package:vismaya/models/myorders.dart';
import 'package:vismaya/models/sign_up_request.dart';
import 'package:vismaya/models/payment.dart';
import 'package:vismaya/models/payment_method.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/models/cms_page.dart';
import 'package:vismaya/models/product_variant.dart';
import 'package:vismaya/models/shipping_billing_request.dart';
import 'package:vismaya/models/shipping_method.dart';
import 'package:vismaya/models/forgot_password.dart';

import 'api_client.dart';
import 'package:http/http.dart' as http;

import 'api_response.dart';

class RemoteRepository {
  ApiClient _apiClient;
  static final RemoteRepository _singleton = RemoteRepository._internal();
  factory RemoteRepository() => _singleton;

  RemoteRepository._internal() {
    _apiClient = ApiClient(httpClient: http.Client());
  }

  Future<Map<String, dynamic>> getStoreConfig() => _apiClient.getStoreConfig();

  Future<ApiResponse<CmsPage>> getCmsPage(String appendedUrl) =>
      _apiClient.getCmsPage(appendedUrl);

  Future<List> getProductAttributeOptions(int attributeId) =>
      _apiClient.getProductAttributeOptions(attributeId);

  Future<ApiResponse<ProductVariant>> getProductVariantBySku(String sku) =>
      _apiClient.getProductVariantBySku(sku);

  Future<ApiResponse<List<Product>>> getBrand(String name) =>
  _apiClient.getBrand(name);

  Future<ApiResponse<List<Category>>> getCategories() =>
      _apiClient.getCategories();

  Future<List> getCategories1() =>
      _apiClient.getCategories1();


  Future<ApiResponse<List<Product>>> getProductsByCategoryId(int categoryId) =>
      _apiClient.getProductsByCategoryId(categoryId);

  Future<ApiResponse<String>> createCart() => _apiClient.createCart();

  Future<ApiResponse<CartItem>> addItemToCart(CartItem cartItem) =>
      _apiClient.addItemToCart(cartItem);

  Future<ApiResponse<CartItem>> updateItemToCart(CartItem cartItem) =>
      _apiClient.updateItemToCart(cartItem);

  Future<ApiResponse<bool>> deleteItemFromCart(int itemId) =>
      _apiClient.deleteItemToCart(itemId);

  Future<ApiResponse<Cart>> getCart() => _apiClient.getCart();

  Future<ApiResponse<Cart>> getCartWithDetails() =>
      _apiClient.getCartWithDetails();

  Future<ApiResponse<CartTotal>> getCartTotal() => _apiClient.getCartTotal();

  Future<ApiResponse<List<ShippingMethod>>> estimateShippingMethods(
          Address shippingAddress) =>
      _apiClient.estimateShippingMethods(shippingAddress);

  Future<ApiResponse<Payment>> setShippingAndBillingInfo(
          ShippingBillingRequest request) =>
      _apiClient.setShippingAndBillingInfo(request);

  Future<ApiResponse<String>> orderNow(PaymentMethod paymentMethod) =>
      _apiClient.orderNow(paymentMethod);

  Future<ApiResponse<Customer>> customerSignUp(SignUpRequest request) =>
      _apiClient.customerSignUp(request);

  Future<ApiResponse<bool>> customerForgotPassword(
          ForgotPasswordRequest request) =>
      _apiClient.customerForgotPassword(request);

  Future<ApiResponse<String>> customerToken(String email, String password) =>
      _apiClient.customerToken(email, password);

  Future<ApiResponse<Customer>> getCustomerInfo() =>
      _apiClient.getCustomerInfo();

  Future<ApiResponse<Customer>> putCustomerInfo(Customer customer) =>
      _apiClient.putCustomerInfo(customer);

  Future<ApiResponse<MyOrder>> getMyOrder(String email) =>
      _apiClient.getMyOrder(email);

  Future<ApiResponse<MyOrder>> getOrdersDetails(String item) =>
      _apiClient.getOrdersDetails(item);

  Future<ApiResponse<bool>> cancelOrder(String entityId) =>
      _apiClient.cancelOrder(entityId);

  Future<ApiResponse<DeliveryTimes>> getDeliveryTimes() =>
      _apiClient.getDeliveryTimes();

  Future<ApiResponse<bool>> setDeliveryTimes(
          SelectedDeliveryTime selectedDeliveryTime) =>
      _apiClient.setDeliveryTimes(selectedDeliveryTime);

  Future<ApiResponse<List<Component>>> getHomeComponentList() =>
      _apiClient.getHomeComponentList();

  Future<ApiResponse<bool>> migrateGuestCart(
          String quoteId, Customer customer) =>
      _apiClient.migrateGuestCart(quoteId, customer);

  Future<ApiResponse<List<Product>>> getProductsBySearch(String termS) =>
      _apiClient.getProductsBySearch(termS);

  
  Future<ApiResponse<List<Product>>> getProductsByFilter(String searchTerm, List<String> brandChecked,
   List<String> sizeChecked, String  categoryChecked, String priceChecked) =>
      _apiClient.getProductsByFilter(searchTerm,brandChecked,sizeChecked,categoryChecked,priceChecked); 

    Future<ApiResponse<List<Product>>> getProductListByFilter(int searchTerm, List<String> brandChecked,
   List<String> sizeChecked, String priceChecked) =>
      _apiClient.getProductListByFilter(searchTerm,brandChecked,sizeChecked,priceChecked); 
  // Future<ApiResponse<List<Product>>> getSearchList(String term) =>
  //     _apiClient.getSearchList(term);
}
