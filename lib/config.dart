import 'dart:convert' as json;
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:vismaya/events/cart_change_event.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/models/cart_item.dart';
import 'package:vismaya/repositories/local/pref_manager.dart';
import 'package:vismaya/utils/rxbus.dart';
import 'package:package_info/package_info.dart';
import 'package:vismaya/utils/utils.dart';

enum Environment { DEV, PROD }

class Config {
  String baseUrl;
  String accessToken;
  String homeCmsBlockId;
  String apiPath;
  Color brandColor;
  Color backgroundColor;
  String brandName;
  Cart cart;
  Map<String, String> headers = Map<String, String>();
  Map<String, String> brandNamesMap = Map<String, String>();
  Map<String, String> packSizesMap = Map<String, String>();
  Map<String, dynamic> categoryNamesMap = Map<String, dynamic>();
  Map<String, dynamic> storeConfig;
  List<String> zipCodes = [];
  String appVersion;
  Future initialized;

  Config() {
    initialized = init();
  }

  init() async {
    final configJson = await loadAsset();
    final config = json.jsonDecode(configJson);
    final _zipCodes = config['zip_codes'] as List;
    zipCodes = _zipCodes.map((e) => e.toString()).toList();
    cart = Cart();
    baseUrl = config['base_url'];
    accessToken = config['access_token'];
    homeCmsBlockId = config['home_cms_block_id'];
    brandColor = Utils.getColorFromHex(config['brand_color']);
    backgroundColor = Utils.getColorFromHex(config['background_color']);
    brandName = config['brand_name'];
    apiPath = '${baseUrl}rest/default';
    headers['Authorization'] = 'Bearer ${this.accessToken}';
    headers['User-Agent'] = 'Mobile app';
    headers['Content-Type'] = 'application/json';
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion = "${packageInfo.version} (${packageInfo.buildNumber})";
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }

  setStoreConfig(Map<String, dynamic> storeConfiguration) {
    storeConfig = storeConfiguration;
  }

  setBrandNamesMap(List list) {
    list.forEach((e) {
      final key = e['value'];
      final value = e['label'];
      brandNamesMap[key] = value;
    });
  }

  setPackSizesMap(List list) {
    list.forEach((e) {
      final key = e['value'];
      final value = e['label'];
      packSizesMap[key] = value;
    });
  }

  setCategoryNamesMap(List list) {
    list.forEach((e) {
      final key = e['value'];
      final value = e['label'];
      categoryNamesMap[key] = value;
    });
  }

  bool get isGuest => prefManager.customerToken.isEmpty;

  String get customerToken => prefManager.customerToken;

  String get quoteId =>
      isGuest ? prefManager.guestQuoteId : prefManager.customerQuoteId;

  setQuoteId(String quoteId) => isGuest
      ? prefManager.setGuestQuoteId(quoteId)
      : prefManager.setCustomerQuoteId(quoteId);

  String getBrandName(String brandValue) {
    return brandNamesMap[brandValue];
  }

  String getPackSize(String packSizeValue) {
    return packSizesMap[packSizeValue];
  }

  String getCategoryName(String categoryValue) {
    return categoryNamesMap[categoryValue];
  }

  String getMediaUrl() {
    return '${storeConfig['base_media_url']}';
  }

  String getProductMediaUrl() {
    return '${storeConfig['base_media_url']}catalog/product';
  }

  CartItem getCartItemBySku(String sku) => cart.getCartItemBySku(sku);

  void putCartItem(String sku, CartItem cartItem) {
    cart.putCartItem(sku, cartItem);
    RxBus.post(CartChangeEvent(sku));
  }

  void removeCartItem(String sku) {
    cart.removeCartItem(sku);
    RxBus.post(CartChangeEvent(sku));
  }

  void clearCart() {
    prefManager.setCustomerQuoteId("");
    prefManager.setGuestQuoteId("");
    this.cart = Cart();
    //Notify
    RxBus.post(CartChangeEvent());
  }
}

Config config = Config();
