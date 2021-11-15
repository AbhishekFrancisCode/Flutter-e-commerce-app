import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:vismaya/app.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/address.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/models/cart_item.dart';
import 'package:vismaya/models/cart_total.dart';
import 'package:vismaya/models/cat.dart';
import 'package:vismaya/models/category.dart';
import 'package:vismaya/models/component.dart';
import 'package:vismaya/models/customer.dart';
import 'package:vismaya/models/delivery_times/delivery_date.dart';
import 'package:vismaya/models/delivery_times/delivery_slot.dart';
import 'package:vismaya/models/delivery_times/delivery_times.dart';
import 'package:vismaya/models/delivery_times/selected_delivery_time.dart';
import 'package:vismaya/models/myorders.dart';
import 'package:vismaya/models/sign_up_request.dart';
import 'package:vismaya/models/payment.dart';
import 'package:vismaya/models/payment_method.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/models/product_variant.dart';
import 'package:vismaya/models/shipping_billing_request.dart';
import 'package:vismaya/models/shipping_method.dart';
import 'package:vismaya/models/forgot_password.dart';
import 'package:vismaya/models/cms_page.dart';
import 'package:vismaya/repositories/remote/api_response.dart';
import 'package:vismaya/utils/utils.dart';

import 'failure.dart';

class ApiClient {
  final http.Client httpClient;

  ApiClient({@required this.httpClient}) : assert(httpClient != null);

  get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${config.accessToken}"
      };

  dynamic get _customerHeaders => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${config.customerToken}"
      };

  Future<Map<String, dynamic>> getStoreConfig() async {
    final baseUrl = config.baseUrl;
    final url = "${baseUrl}rest/V1/store/storeConfigs";
    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      final list = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return list[0] as Map;
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<List> getProductAttributeOptions(int attributeId) async {
    final baseUrl = config.baseUrl;
    final url = "${baseUrl}rest/V1/products/attributes/$attributeId/options";
    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      final list = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return list;
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<List<Product>>> getBrand(String name) async {
    final params = <String, dynamic>{
      'searchCriteria[filter_groups][1][filters][0][field]': 'brand',
      'searchCriteria[filter_groups][1][filters][0][value]': name,
      'searchCriteria[filter_groups][1][filters][0][condition_type]': 'like',
      'searchCriteria[filter_groups][2][filters][0][field]': 'type_id',
      'searchCriteria[filter_groups][2][filters][0][value]': 'simple',
      'searchCriteria[filter_groups][2][filters][0][condition_type]': 'like',
    };
    final response = await getProducts(params);

    List<Product> list = [];
    Set<String> set = Set();
    for (int i = 0; i < response.data.length; i++) {
      final item = response.data[i];
      list.add(item);
    }

    return ApiResponse(data: list);
  }

  Future<List> getCategories1() async {
    List list3 = [];
    final baseUrl = config.baseUrl;
    final url = "${baseUrl}rest/V1/categories";
    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      Cat category = Cat.fromJson(json);

      for (var i = 0; i < category.childrenData.length; i++) {
        var productMap = {
          "label": category.childrenData[i].name,
          "value": category.childrenData[i].id.toString()
        };
        list3.add(productMap);

        if (category.childrenData[i].childrenData.length > 0) {
          for (var j = 0;
              j < category.childrenData[i].childrenData.length;
              j++) {
            productMap = {
              "label": category.childrenData[i].childrenData[j].name,
              "value": category.childrenData[i].childrenData[j].id.toString()
            };
            list3.add(productMap);

            if (category.childrenData[i].childrenData[j].childrenData.length >
                0) {
              for (var k = 0;
                  k <
                      category
                          .childrenData[i].childrenData[j].childrenData.length;
                  k++) {
                productMap = {
                  "label": category
                      .childrenData[i].childrenData[j].childrenData[k].name,
                  "value": category
                      .childrenData[i].childrenData[j].childrenData[k].id
                      .toString()
                };
                list3.add(productMap);

                if (category.childrenData[i].childrenData[j].childrenData[k]
                        .childrenData.length >
                    0) {
                  for (var l = 0;
                      l <
                          category.childrenData[i].childrenData[j]
                              .childrenData[k].childrenData.length;
                      l++) {
                    productMap = {
                      "label": category.childrenData[i].childrenData[j]
                          .childrenData[k].childrenData[l].name,
                      "value": category.childrenData[i].childrenData[j]
                          .childrenData[k].childrenData[l].id
                          .toString()
                    };
                    list3.add(productMap);
                  }
                }
              }
            }
          }
        }
      }
      return list3;
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<CmsPage>> getCmsPage(String cmsUrl) async {
    final baseUrl = config.baseUrl;
    final url = '${baseUrl}rest/V1/$cmsUrl';
    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final profile = CmsPage.fromJson(json);
      return ApiResponse(data: profile);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<List<Component>>> getHomeComponentList() async {
    final baseUrl = config.baseUrl;
    final url = '${baseUrl}rest/V1/cmsBlock/19';
    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      final content = responseJson["content"].toString();
      final _contentJsonStr = Utils.removeAllHtmlTags(content);
      final _contentJson = jsonDecode(_contentJsonStr);
      final list = Component.fromJson(_contentJson);
      return ApiResponse(data: list);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<List<Category>>> getCategories() async {
    final baseUrl = config.baseUrl;
    final url = "${baseUrl}rest/V1/categories";
    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final category = Category.fromJson(json);
      return ApiResponse(data: category.children);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<ProductVariant>> getProductVariantBySku(String sku) async {
    final baseUrl = config.baseUrl;
    final url = "${baseUrl}rest/V1/products/$sku";
    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final product = ProductVariant.fromJson(json);
      return ApiResponse(data: product);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  //TODO: Support pagination
  Future<ApiResponse<List<Product>>> getProductsByCategoryId(
      int categoryId) async {
    final params = <String, dynamic>{
      'searchCriteria[filterGroups][0][filters][0][field]': 'category_id',
      'searchCriteria[filterGroups][0][filters][0][value]': categoryId,
      'searchCriteria[filterGroups][1][filters][0][field]': 'type_id',
      'searchCriteria[filterGroups][1][filters][0][value]': 'simple',
      'searchCriteria[sortOrders][0][field]': 'name',
      'searchCriteria[sortOrders][0][direction]': 'ASC',
      // 'searchCriteria[filterGroups][0][filters][0][conditionType]': 'eq',
      // 'searchCriteria[filterGroups][1][filters][0][field]': 'visibility',
      // 'searchCriteria[filterGroups][1][filters][0][value]': '4',
      // 'searchCriteria[filterGroups][1][filters][0][conditionType]': 'eq',
      // 'searchCriteria[pageSize]': pageSize,
      // 'searchCriteria[currentPage]': currentPage
    };
    return getProducts(params);
  }

  // Future<ApiResponse<List<Product>>> getSearchList(String term) async {
  //   final params = <String, dynamic>{
  //     'searchCriteria[filter_groups][0][filters][0][field]': 'name',
  //     'searchCriteria[filter_groups][0][filters][0][value]': '%$term%',
  //     'searchCriteria[filter_groups][0][filters][0][condition_type]': 'like',
  //     'searchCriteria[requestName]': 'quick_search_container',
  //     // 'searchCriteria[filterGroups][1][filters][0][field]': 'visibility',
  //     // 'searchCriteria[filterGroups][1][filters][0][value]': '4',
  //     // 'searchCriteria[filterGroups][1][filters][0][conditionType]': 'eq',
  //     // 'searchCriteria[pageSize]': pageSize,
  //     // 'searchCriteria[currentPage]': currentPage
  //   };
  //   String paramsString = '';
  //   String separator = '?';
  //   params.forEach((key, value) {
  //     paramsString = '$paramsString$separator$key=$value';
  //     separator = '&';
  //   });

  //   final url = "${config.baseUrl}rest/V1/search$paramsString";

  //   final response = await _getResponse(url, _headers);
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(utf8.decode(response.bodyBytes));
  //     final items = json['items'] as List;

  //     return ApiResponse(data: []);
  //   } else {
  //     final code = response.statusCode;
  //     throw Failure("Unable to process the request ($code)");
  //   }
  // }
  Future<ApiResponse<List<Product>>> getProductListByFilter(
      int categoryId,
      List<String> brandChecked,
      List<String> sizeChecked,
      String priceChecked) async {
    final params = <String, dynamic>{
      'searchCriteria[filter_groups][0][filters][0][field]': 'category_id',
      'searchCriteria[filter_groups][0][filters][0][value]': categoryId,
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'in',
      'searchCriteria[filter_groups][1][filters][0][field]': 'type_id',
      'searchCriteria[filter_groups][1][filters][0][value]': 'simple',
      'searchCriteria[filter_groups][1][filters][0][condition_type]': 'like',
    };
    var group0 = 2;
    _getProducts(List list, String name) {
      var field = list == brandChecked
          ? 'brand'
          : list == sizeChecked
              ? 'size'
              : name == priceChecked
                  ? 'price'
                  : 'categoryId';
      var condition = list == brandChecked
          ? 'like'
          : list == sizeChecked
              ? 'like'
              : name == priceChecked
                  ? 'to'
                  : 'in';
      if (list == null && name != null) {
        params.addAll({
          'searchCriteria[filter_groups][$group0][filters][0][field]': '$field',
          'searchCriteria[filter_groups][$group0][filters][0][value]': '$name',
          'searchCriteria[filter_groups][$group0][filters][0][condition_type]':
              '$condition',
        });
      } else if (list != null && name == null) {
        for (int i = 0; i < list.length; i++) {
          final item = list[i];
          params.addAll({
            'searchCriteria[filter_groups][$group0][filters][$i][field]':
                '$field',
            'searchCriteria[filter_groups][$group0][filters][$i][value]':
                '$item',
            'searchCriteria[filter_groups][$group0][filters][$i][condition_type]':
                '$condition',
          });
        }
      }
      group0++;
    }

    if (brandChecked != null) {
      _getProducts(brandChecked, null);
    }
    if (sizeChecked != null) {
      _getProducts(sizeChecked, null);
    }
    // if (categoryChecked != null) {
    //   _getProducts(null, categoryChecked);
    // }
    if (brandChecked != null) {
      _getProducts(null, priceChecked);
    }

    final response = await getProducts(params);

    List<Product> list = [];
    Set<String> set = Set();
    for (int i = 0; i < response.data.length; i++) {
      final item = response.data[i];
      list.add(item);
    }

    return ApiResponse(data: list);
  }

  Future<ApiResponse<List<Product>>> getProductsByFilter(
      String termS,
      List<String> brandChecked,
      List<String> sizeChecked,
      String categoryChecked,
      String priceChecked) async {
    final terms = termS.split(RegExp(r"\s+"));
    categoryChecked = categoryChecked == '0' ? categoryChecked = null : categoryChecked;
    //Search for the whole term
    final params1 = <String, dynamic>{
      'searchCriteria[filter_groups][0][filters][0][field]': 'name',
      'searchCriteria[filter_groups][0][filters][0][value]': '%25%20$termS%25',
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'like',
      'searchCriteria[filter_groups][0][filters][1][field]': 'name',
      'searchCriteria[filter_groups][0][filters][1][value]': '%25$termS%20%25',
      'searchCriteria[filter_groups][0][filters][1][condition_type]': 'like',
      'searchCriteria[filter_groups][0][filters][2][field]': 'name',
      'searchCriteria[filter_groups][0][filters][2][value]': '%25$termS%25',
      'searchCriteria[filter_groups][0][filters][2][condition_type]': 'like',
      'searchCriteria[filter_groups][1][filters][0][field]': 'type_id',
      'searchCriteria[filter_groups][1][filters][0][value]': 'simple',
      'searchCriteria[filter_groups][1][filters][0][condition_type]': 'eq',
      // 'searchCriteria[filterGroups][1][filters][0][field]': 'visibility',
      // 'searchCriteria[filterGroups][1][filters][0][value]': '4',
      // 'searchCriteria[filterGroups][1][filters][0][conditionType]': 'eq',
      // 'searchCriteria[pageSize]': pageSize,
      // 'searchCriteria[currentPage]': currentPage
    };
    var group0 = 2;
    if (brandChecked != null) {
      for (int i = 0; i < brandChecked.length; i++) {
        final item = brandChecked[i];
        params1.addAll({
          'searchCriteria[filter_groups][$group0][filters][$i][field]': 'brand',
          'searchCriteria[filter_groups][$group0][filters][$i][value]': '$item',
          'searchCriteria[filter_groups][$group0][filters][$i][condition_type]':
              'like',
        });
        group0++;
      }
    }
    if (sizeChecked != null) {
      for (int i = 0; i < sizeChecked.length; i++) {
        final item = sizeChecked[i];
        params1.addAll({
          'searchCriteria[filter_groups][$group0][filters][$i][field]': 'size',
          'searchCriteria[filter_groups][$group0][filters][$i][value]': '$item',
          'searchCriteria[filter_groups][$group0][filters][$i][condition_type]':
              'like',
        });
      }
      group0++;
    }
    if (categoryChecked != null) {
      final item = categoryChecked;
      params1.addAll({
        'searchCriteria[filter_groups][$group0][filters][0][field]':
            'category_id',
        'searchCriteria[filter_groups][$group0][filters][0][value]': '$item',
        'searchCriteria[filter_groups][$group0][filters][0][condition_type]':
            'in',
      });
      group0++;
    }
    if (priceChecked != null) {
      var groupp = group0 + 1;
      final item = priceChecked;
      var condition = priceChecked == '20'
          ? 0
          : priceChecked == '50'
              ? 21
              : priceChecked == '100'
                  ? 51
                  : priceChecked == '200'
                      ? 101
                      : priceChecked == '500'
                          ? 201
                          : priceChecked == '10000'
                              ? 0
                              : 0;
      params1.addAll({
        'searchCriteria[filter_groups][$group0][filters][0][field]': 'price',
        'searchCriteria[filter_groups][$group0][filters][0][value]':
            '$condition',
        'searchCriteria[filter_groups][$group0][filters][0][condition_type]':
            'from',
        'searchCriteria[filter_groups][$groupp][filters][0][field]': 'price',
        'searchCriteria[filter_groups][$groupp][filters][0][value]': '$item',
        'searchCriteria[filter_groups][$groupp][filters][0][condition_type]':
            'to',
      });
      group0 = 2;
    }

    //Search with split terms
    var group = 2;
    final params2 = <String, dynamic>{
      'searchCriteria[filter_groups][1][filters][0][field]': 'type_id',
      'searchCriteria[filter_groups][1][filters][0][value]': 'simple',
      'searchCriteria[filter_groups][1][filters][0][condition_type]': 'eq',
    };
    for (var i = 0; i < terms.length; i++) {
      // final group = i + 2;
      final item = terms[i];
      params2.addAll({
        'searchCriteria[filter_groups][$group][filters][0][field]': 'name',
        'searchCriteria[filter_groups][$group][filters][0][value]':
            '%25$item%25',
        'searchCriteria[filter_groups][$group][filters][0][condition_type]':
            'like',
        'searchCriteria[filter_groups][$group][filters][1][field]': 'name',
        'searchCriteria[filter_groups][$group][filters][1][value]':
            '%25%20$termS%25',
        'searchCriteria[filter_groups][$group][filters][1][condition_type]':
            'like',
        'searchCriteria[filter_groups][$group][filters][2][field]': 'name',
        'searchCriteria[filter_groups][$group][filters][2][value]':
            '%25$termS%20%25',
        'searchCriteria[filter_groups][$group][filters][2][condition_type]':
            'like',
        'searchCriteria[filter_groups][$group][filters][3][field]': 'name',
        'searchCriteria[filter_groups][$group][filters][3][value]':
            '%25$termS%25',
        'searchCriteria[filter_groups][$group][filters][3][condition_type]':
            'like',
      });
      group++;
    }

    if (brandChecked != null) {
      for (int i = 0; i < brandChecked.length; i++) {
        final group = terms.length + 2;
        final item = brandChecked[i];
        params2.addAll({
          'searchCriteria[filter_groups][$group][filters][$i][field]': 'brand',
          'searchCriteria[filter_groups][$group][filters][$i][value]': '$item',
          'searchCriteria[filter_groups][$group][filters][$i][condition_type]':
              'like',
        });
      }
      group++;
    }
    if (sizeChecked != null) {
      for (int i = 0; i < sizeChecked.length; i++) {
        final item = sizeChecked[i];
        params2.addAll({
          'searchCriteria[filter_groups][$group][filters][$i][field]': 'size',
          'searchCriteria[filter_groups][$group][filters][$i][value]': '$item',
          'searchCriteria[filter_groups][$group][filters][$i][condition_type]':
              'like',
        });
      }
      group++;
    }

    if (categoryChecked != null ) {
      final item = categoryChecked;
      params2.addAll({
        'searchCriteria[filter_groups][$group0][filters][0][field]':
            'category_id',
        'searchCriteria[filter_groups][$group0][filters][0][value]': '$item',
        'searchCriteria[filter_groups][$group0][filters][0][condition_type]':
            'in',
      });
    }
    if (priceChecked != null) {
      var groupp = group + 1;
      final item = priceChecked;
      var condition = priceChecked == '20'
          ? 0
          : priceChecked == '50'
              ? 21
              : priceChecked == '100'
                  ? 51
                  : priceChecked == '200'
                      ? 101
                      : priceChecked == '500'
                          ? 201
                          : priceChecked == '10000'
                              ? 0
                              : 0;
      params2.addAll({
        'searchCriteria[filter_groups][$group][filters][0][field]': 'price',
        'searchCriteria[filter_groups][$group][filters][0][value]':
            '$condition',
        'searchCriteria[filter_groups][$group][filters][0][condition_type]':
            'from',
        'searchCriteria[filter_groups][$groupp][filters][0][field]': 'price',
        'searchCriteria[filter_groups][$groupp][filters][0][value]': '$item',
        'searchCriteria[filter_groups][$groupp][filters][0][condition_type]':
            'to',
      });
    }

    final params3 = <String, dynamic>{
      'searchCriteria[filter_groups][0][filters][0][field]': 'type_id',
      'searchCriteria[filter_groups][0][filters][0][value]': 'simple',
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'eq',
    };
    group = 1;
    for (var i = 0; i < terms.length; i++) {
      final item = terms[i];
      params3.addAll({
        'searchCriteria[filter_groups][$group][filters][$i][field]': 'name',
        'searchCriteria[filter_groups][$group][filters][$i][value]':
            '%25$item%25',
        'searchCriteria[filter_groups][$group][filters][$i][condition_type]':
            'like',
      });
    }
    group++;

    if (brandChecked != null) {
      for (int i = 0; i < brandChecked.length; i++) {
        final item = brandChecked[i];
        params3.addAll({
          'searchCriteria[filter_groups][$group][filters][$i][field]': 'brand',
          'searchCriteria[filter_groups][$group][filters][$i][value]': '$item',
          'searchCriteria[filter_groups][$group][filters][$i][condition_type]':
              'like',
        });
      }
      group++;
    }
    if (sizeChecked != null) {
      for (int i = 0; i < sizeChecked.length; i++) {
        final item = sizeChecked[i];
        params3.addAll({
          'searchCriteria[filter_groups][$group][filters][$i][field]': 'size',
          'searchCriteria[filter_groups][$group][filters][$i][value]': '$item',
          'searchCriteria[filter_groups][$group][filters][$i][condition_type]':
              'like',
        });
      }
      group++;
    }

    if (categoryChecked != null) {
      final item = categoryChecked;
      params3.addAll({
        'searchCriteria[filter_groups][$group0][filters][0][field]':
            'category_id',
        'searchCriteria[filter_groups][$group0][filters][0][value]': '$item',
        'searchCriteria[filter_groups][$group0][filters][0][condition_type]':
            'in',
      });
      group++;
    }
    if (priceChecked != null) {
      var groupp = group + 1;
      final item = priceChecked;
      var condition = priceChecked == '20'
          ? 0
          : priceChecked == '50'
              ? 21
              : priceChecked == '100'
                  ? 51
                  : priceChecked == '200'
                      ? 101
                      : priceChecked == '500'
                          ? 201
                          : priceChecked == '10000'
                              ? 0
                              : 0;
      params3.addAll({
        'searchCriteria[filter_groups][$group][filters][0][field]': 'price',
        'searchCriteria[filter_groups][$group][filters][0][value]':
            '$condition',
        'searchCriteria[filter_groups][$group][filters][0][condition_type]':
            'from',
        'searchCriteria[filter_groups][$groupp][filters][0][field]': 'price',
        'searchCriteria[filter_groups][$groupp][filters][0][value]': '$item',
        'searchCriteria[filter_groups][$groupp][filters][0][condition_type]':
            'to',
      });
      group = 2;
    }
    final response1 = await getProducts(params1);
    final response2 = await getProducts(params2);
    final response3 = await getProducts(params3);

    List<Product> list = [];
    Set<String> set = Set();
    for (int i = 0; i < response1.data.length; i++) {
      final item = response1.data[i];
      list.add(item);
      set.add(item.getGroupName());
    }

    for (int i = 0; i < response2.data.length; i++) {
      final item = response2.data[i];
      if (!set.contains(item.getGroupName())) {
        list.add(item);
        set.add(item.getGroupName());
      }
    }
    for (int i = 0; i < response3.data.length; i++) {
      final item = response3.data[i];
      if (!set.contains(item.getGroupName())) {
        list.add(item);
      }
    }

    return ApiResponse(data: list);
  }

  Future<ApiResponse<List<Product>>> getProductsBySearch(String termS) async {
    //Search for the whole term
    final params1 = <String, dynamic>{
      'searchCriteria[filter_groups][0][filters][0][field]': 'name',
      'searchCriteria[filter_groups][0][filters][0][value]': '%25%20$termS%25',
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'like',
      'searchCriteria[filter_groups][0][filters][1][field]': 'name',
      'searchCriteria[filter_groups][0][filters][1][value]': '%25$termS%20%25',
      'searchCriteria[filter_groups][0][filters][1][condition_type]': 'like',
      'searchCriteria[filter_groups][0][filters][2][field]': 'name',
      'searchCriteria[filter_groups][0][filters][2][value]': '%25$termS%25',
      'searchCriteria[filter_groups][0][filters][2][condition_type]': 'like',
      'searchCriteria[filter_groups][1][filters][0][field]': 'type_id',
      'searchCriteria[filter_groups][1][filters][0][value]': 'simple',
      'searchCriteria[filter_groups][1][filters][0][condition_type]': 'eq',
      // 'searchCriteria[filterGroups][1][filters][0][field]': 'visibility',
      // 'searchCriteria[filterGroups][1][filters][0][value]': '4',
      // 'searchCriteria[filterGroups][1][filters][0][conditionType]': 'eq',
      // 'searchCriteria[pageSize]': pageSize,
      // 'searchCriteria[currentPage]': currentPage
    };
    // if (termF != null) {
    //   params1.addAll({
    //     'searchCriteria[filter_groups][2][filters][0][field]': 'brand',
    //     'searchCriteria[filter_groups][2][filters][0][value]': '%25$termF%25',
    //     'searchCriteria[filter_groups][2][filters][0][condition_type]': 'like',
    //   });
    // }

    //Search with split terms
    final params2 = <String, dynamic>{
      'searchCriteria[filter_groups][1][filters][0][field]': 'type_id',
      'searchCriteria[filter_groups][1][filters][0][value]': 'simple',
      'searchCriteria[filter_groups][1][filters][0][condition_type]': 'eq',
    };
    final terms = termS.split(RegExp(r"\s+"));
    for (var i = 0; i < terms.length; i++) {
      final group = i + 3;
      final item = terms[i];
      params2.addAll({
        'searchCriteria[filter_groups][$group][filters][0][field]': 'name',
        'searchCriteria[filter_groups][$group][filters][0][value]':
            '%25$item%25',
        'searchCriteria[filter_groups][$group][filters][0][condition_type]':
            'like',
        'searchCriteria[filter_groups][$group][filters][1][field]': 'name',
        'searchCriteria[filter_groups][$group][filters][1][value]':
            '%25%20$termS%25',
        'searchCriteria[filter_groups][$group][filters][1][condition_type]':
            'like',
        'searchCriteria[filter_groups][$group][filters][2][field]': 'name',
        'searchCriteria[filter_groups][$group][filters][2][value]':
            '%25$termS%20%25',
        'searchCriteria[filter_groups][$group][filters][2][condition_type]':
            'like',
        'searchCriteria[filter_groups][$group][filters][3][field]': 'name',
        'searchCriteria[filter_groups][$group][filters][3][value]':
            '%25$termS%25',
        'searchCriteria[filter_groups][$group][filters][3][condition_type]':
            'like',
      });
    }
    // if (termF != null) {
    //   params2.addAll({
    //     'searchCriteria[filter_groups][2][filters][0][field]': 'brand',
    //     'searchCriteria[filter_groups][2][filters][0][value]': '%25$termF%25',
    //     'searchCriteria[filter_groups][2][filters][0][condition_type]': 'like',
    //   });
    // }

    final params3 = <String, dynamic>{
      'searchCriteria[filter_groups][0][filters][0][field]': 'type_id',
      'searchCriteria[filter_groups][0][filters][0][value]': 'simple',
      'searchCriteria[filter_groups][0][filters][0][condition_type]': 'eq',
    };
    for (var i = 0; i < terms.length; i++) {
      final group = i;
      final item = terms[i];
      params3.addAll({
        'searchCriteria[filter_groups][1][filters][$group][field]': 'name',
        'searchCriteria[filter_groups][1][filters][$group][value]':
            '%25$item%25',
        'searchCriteria[filter_groups][1][filters][$group][condition_type]':
            'like',
      });
    }
    // if (termF != null) {
    //   final filter = terms.length + 1;
    //   params3.addAll({
    //     'searchCriteria[filter_groups][$filter][filters][0][field]': 'brand',
    //     'searchCriteria[filter_groups][$filter][filters][0][value]': '%25$termF%25',
    //     'searchCriteria[filter_groups][$filter][filters][0][condition_type]': 'like',
    //   });
    // }

    final response1 = await getProducts(params1);
    final response2 = await getProducts(params2);
    final response3 = await getProducts(params3);

    List<Product> list = [];
    Set<String> set = Set();
    for (int i = 0; i < response1.data.length; i++) {
      final item = response1.data[i];
      list.add(item);
      set.add(item.getGroupName());
    }

    for (int i = 0; i < response2.data.length; i++) {
      final item = response2.data[i];
      if (!set.contains(item.getGroupName())) {
        list.add(item);
        set.add(item.getGroupName());
      }
    }
    for (int i = 0; i < response3.data.length; i++) {
      final item = response3.data[i];
      if (!set.contains(item.getGroupName())) {
        list.add(item);
      }
    }

    return ApiResponse(data: list);
  }

  Future<ApiResponse<List<Product>>> getProducts(
      Map<String, dynamic> params) async {
    String paramsString = '';
    String separator = '?';
    params.forEach((key, value) {
      paramsString = '$paramsString$separator$key=$value';
      separator = '&';
    });

    final url = "${config.baseUrl}rest/V1/products$paramsString";

    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return ApiResponse(data: []);
      }
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final items = json['items'] as List;

      final variants = items.map((e) => ProductVariant.fromJson(e)).toList();

      //Sort variants
      Utils.insertionSort<ProductVariant>(variants, (v1, v2) {
        final group1 = v1.name + v1.brandValue;
        final group2 = v2.name + v2.brandValue;
        return group1.compareTo(group2);
      });

      List<Product> products = [];
      Product product;
      for (var variant in variants) {
        final name = variant.name;
        final brand = variant.getBrand();
        final groupName = "$brand-$name";
        // final productGroupName = product?.getGroupName() ?? "";
        if (product?.getGroupName() != groupName) {
          product = Product(name: name);
          products.add(product);
        }
        product.variants.add(variant);
      }
      return ApiResponse(data: products);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  /*
   *  Cart API
   */

  Future<ApiResponse<String>> createCart() async {
    final isGuest = config.customerToken.isEmpty;
    final urlSuffix = isGuest ? "guest-carts" : "carts/mine";
    final url = "${config.baseUrl}rest/V1/$urlSuffix";
    final headers = isGuest ? _headers : _customerHeaders;
    final response = await _postResponse(url, headers: headers);
    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes);
      final _data = data.replaceAll("\"", "");
      return ApiResponse(data: _data);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<CartItem>> addItemToCart(CartItem cartItem) async {
    final isGuest = config.customerToken.isEmpty;
    final urlSuffix =
        isGuest ? "guest-carts/${cartItem.quoteId}/items" : "carts/mine/items";
    final url = "${config.baseUrl}rest/V1/$urlSuffix";
    final headers = isGuest ? _headers : _customerHeaders;
    final response = await _postResponse(url,
        body: cartItem.toPayloadJson(), headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final cartItem = CartItem.fromResponseJson(json);
      return ApiResponse(data: cartItem);
    } else {
      final code = response.statusCode;
      if (code == 400) {
        final message = json["message"];
        throw Failure(message);
      } else {
        throw Failure("Something went wrong ($code). Please retry!");
      }
    }
  }

  Future<ApiResponse<CartItem>> updateItemToCart(CartItem cartItem) async {
    final isGuest = config.customerToken.isEmpty;
    final quoteId = config.quoteId;
    final itemId = cartItem.itemId;
    final urlSuffix =
        isGuest ? "guest-carts/$quoteId/items" : "carts/mine/items";
    final url = "${config.baseUrl}rest/V1/$urlSuffix/$itemId";
    final headers = isGuest ? _headers : _customerHeaders;
    final response = await _putResponse(url,
        body: cartItem.toUpdatePayloadJson(), headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final cartItem = CartItem.fromResponseJson(json);
      return ApiResponse(data: cartItem);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<bool>> deleteItemToCart(int itemId) async {
    final isGuest = config.customerToken.isEmpty;
    final quoteId = config.quoteId;
    final urlSuffix =
        isGuest ? "guest-carts/$quoteId/items" : "carts/mine/items";
    final url = "${config.baseUrl}rest/V1/$urlSuffix/$itemId";
    final headers = isGuest ? _headers : _customerHeaders;
    final response = await _deleteResponse(url, headers: headers);
    if (response.statusCode == 200) {
      return ApiResponse(data: true);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<bool>> migrateGuestCart(
      String quoteId, Customer customer) async {
    final url = "${config.baseUrl}rest/V1/guest-carts/$quoteId";
    final body =
        jsonEncode({"customerId": customer.id, "storeId": customer.storeId});
    final response =
        await _putResponse(url, body: body, headers: _customerHeaders);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return ApiResponse(data: json);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<Cart>> getCart() async {
    final isGuest = config.customerToken.isEmpty;
    if (isGuest && config.quoteId.isEmpty) {
      return ApiResponse(data: Cart());
    }
    final urlSuffix = isGuest ? "guest-carts/${config.quoteId}" : "carts/mine";
    final url = "${config.baseUrl}rest/V1/$urlSuffix";
    final headers = isGuest ? _headers : _customerHeaders;
    final response = await _getResponse(url, headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final cart = Cart.fromJson(json);
      if (cart.isActive) {
        return ApiResponse(data: cart);
      } else {
        config.cart = Cart();
        config.setQuoteId("");
        return ApiResponse(data: config.cart);
      }
    } else if (response.statusCode == 404) {
      config.cart = Cart();
      config.setQuoteId("");
      return ApiResponse(data: config.cart);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<Cart>> getCartWithDetails() async {
    final response = await getCart();
    final cart = response.data;
    for (final _item in cart.items) {
      final response = await getProductVariantBySku(_item.sku);
      final variant = response.data;
      _item.brand = variant.getBrand();
      _item.size = variant.getSize();
      _item.imageUrl = variant.getThumbnailImageUrl();
    }
    return ApiResponse(data: cart);
  }

  Future<ApiResponse<CartTotal>> getCartTotal() async {
    final isGuest = config.isGuest;
    if (isGuest && config.quoteId.isEmpty) {
      return ApiResponse(data: CartTotal());
    }
    String urlSuffix = isGuest ? "guest-carts/${config.quoteId}" : "carts/mine";
    final url = "${config.baseUrl}rest/V1/$urlSuffix/totals";
    final headers = isGuest ? _headers : _customerHeaders;
    final response = await _getResponse(url, headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final cartTotal = CartTotal.fromResponseJson(json);
      return ApiResponse(data: cartTotal);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  // Future<ApiResponse<List<ShippingMethod>>> getShippingMethods() async {
  //   if (config.quoteId.isEmpty) {
  //     return ApiResponse(data: []);
  //   }
  //   final _isGuest = config.customerToken.isEmpty;
  //   final urlSuffix = _isGuest ? "guest-carts/${config.quoteId}" : "carts/mine";
  //   final url = "${config.baseUrl}rest/V1/$urlSuffix/shipping-methods";
  //   final token = _isGuest ? config.accessToken : config.customerToken;
  //   final headers = {
  //     "Content-Type": "application/json",
  //     "Accept": "application/json",
  //     "Authorization": "Bearer $token"
  //   };
  //   final response = await _getResponse(url, headers);
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(utf8.decode(response.bodyBytes));
  //     // final cartTotal = CartTotal.fromResponseJson(json);
  //     return ApiResponse(data: []);
  //   } else {
  //     final code = response.statusCode;
  //     throw Failure("Unable to process the request ($code)");
  //   }
  // }

  Future<ApiResponse<List<ShippingMethod>>> estimateShippingMethods(
      Address shippingAddress) async {
    final isGuest = config.customerToken.isEmpty;
    final urlSuffix = isGuest ? "guest-carts/${config.quoteId}" : "carts/mine";
    final url = "${config.baseUrl}rest/V1/$urlSuffix/estimate-shipping-methods";
    final headers = isGuest ? _headers : _customerHeaders;
    final response = await _postResponse(url,
        body: shippingAddress.toJson(), headers: headers);
    if (response.statusCode == 200) {
      final list = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      final shippingMethods = list.map((element) {
        return ShippingMethod.fromJson(element);
      }).toList();
      return ApiResponse(data: shippingMethods);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<Payment>> setShippingAndBillingInfo(
      ShippingBillingRequest request) async {
    final isGuest = config.customerToken.isEmpty;
    final urlSuffix = isGuest ? "guest-carts/${config.quoteId}" : "carts/mine";
    final url = "${config.baseUrl}rest/V1/$urlSuffix/shipping-information";
    final headers = isGuest ? _headers : _customerHeaders;
    final response =
        await _postResponse(url, body: request.toJson(), headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final payment = Payment.fromJson(json);
      return ApiResponse(data: payment);
    } else {
      final code = response.statusCode;
      throw Failure("Unable to process the request ($code)");
    }
  }

  Future<ApiResponse<String>> orderNow(PaymentMethod paymentMethod) async {
    final isGuest = config.customerToken.isEmpty;
    final urlSuffix = isGuest ? "guest-carts/${config.quoteId}" : "carts/mine";
    final url = "${config.baseUrl}rest/V1/$urlSuffix/order";
    final headers = isGuest ? _headers : _customerHeaders;
    final _body = jsonEncode({
      "paymentMethod": {"method": paymentMethod.code}
    });
    final response = await _putResponse(url, body: _body, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return ApiResponse(data: json);
    } else {
      throw Failure(json["message"]);
    }
  }

  /*
   * Customer sign in
   */
  Future<ApiResponse<Customer>> customerSignUp(SignUpRequest request) async {
    final url = "${config.baseUrl}rest/V1/customers";
    final response = await _postResponse(url,
        body: request.toRequestJson(), headers: _headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final customer = Customer.fromJson(json);
      return ApiResponse(data: customer);
    } else {
      final code = response.statusCode;
      if (code == 400) {
        throw Failure(json['message']);
      } else {
        throw Failure("Something went wrong ($code). Please retry!");
      }
    }
  }

  Future<ApiResponse<bool>> customerForgotPassword(
      ForgotPasswordRequest request) async {
    final url = "${config.baseUrl}rest/V1/customers/password";
    final response = await _putResponse(url,
        body: request.toRequestJsonFP(), headers: _headers);
    if (response.statusCode == 200) {
      jsonDecode(utf8.decode(response.bodyBytes));
      return ApiResponse(data: true);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<String>> customerToken(
      String email, String password) async {
    final url = "${config.baseUrl}rest/V1/integration/customer/token";
    final requestJson = jsonEncode({"username": email, "password": password});
    final response =
        await _postResponse(url, body: requestJson, headers: _headers);

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return ApiResponse(data: json);
    } else {
      final code = response.statusCode;
      if (code == 401) {
        throw Failure(json['message']);
      } else {
        throw Failure("Something went wrong ($code). Please retry!");
      }
    }
  }

  Future<ApiResponse<Customer>> getCustomerInfo() async {
    final url = "${config.baseUrl}rest/V1/customers/me";
    final response = await _getResponse(url, _customerHeaders);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final customer = Customer.fromJson(json);
      return ApiResponse(data: customer);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<Customer>> putCustomerInfo(Customer customer) async {
    final url = "${config.baseUrl}rest/V1/customers/me";
    final body = customer.toRequestJson();
    final response =
        await _putResponse(url, body: body, headers: _customerHeaders);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final customer = Customer.fromJson(json);
      return ApiResponse(data: customer);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

/*
 * My Order detail 
 */
  Future<ApiResponse<MyOrder>> getMyOrder(String email) async {
    final params = <String, dynamic>{
      'searchCriteria[filterGroups][0][filters][0][field]': 'customer_email',
      'searchCriteria[filterGroups][0][filters][0][value]': email,
    };

    String paramsString = '';
    String separator = '?';
    params.forEach((key, value) {
      paramsString = '$paramsString$separator$key=$value';
      separator = '&';
    });

    final url = "${config.baseUrl}rest/V1/orders$paramsString";
    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final orders = MyOrder.fromJson(json);
      return ApiResponse(data: orders);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<MyOrder>> getOrdersDetails(String item) async {
    final params = <String, dynamic>{
      'searchCriteria[filterGroups][0][filters][0][field]': 'increment_id',
      'searchCriteria[filterGroups][0][filters][0][value]': item,
    };

    String paramsString = '';
    String separator = '?';
    params.forEach((key, value) {
      paramsString = '$paramsString$separator$key=$value';
      separator = '&';
    });

    final url = "${config.baseUrl}rest/V1/orders$paramsString";
    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final orders = MyOrder.fromJson(json);
      return ApiResponse(data: orders);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<bool>> cancelOrder(String entityId) async {
    final url = "${config.baseUrl}rest/V1/orders/$entityId/cancel";
    final response = await httpClient.post(url, headers: _headers);
    if (response.statusCode == 200) {
      jsonDecode(utf8.decode(response.bodyBytes));
      return ApiResponse(data: true);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<DeliveryTimes>> getDeliveryTimes() async {
    final url = "${config.baseUrl}rest/V1/delivery-schedule/details";
    final response = await _getResponse(url, _headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      final item = json[0];
      final map = Map<String, DeliveryDate>();
      final description = item["description"] ?? "";
      final availableDays = item["avaiableDays"] as List;
      for (final day in availableDays) {
        final available = day["avaiable"];
        if (available == 0) continue;
        final dtimeId = day["dtime_id"];
        final date = day["date"];
        final deliveryDate = map[date] ?? DeliveryDate();
        deliveryDate.date = date;
        deliveryDate.availableDtimeIds.add(dtimeId);
        map[date] = deliveryDate;
      }

      //Slots
      final slots = item["calenderTime"] as List;
      final deliverySlots = slots.map((e) {
        final dtimeId = e["dtime_id"];
        final dtime = e["dtime"];
        return DeliverySlot(dtime: dtime, dtimeId: dtimeId);
      }).toList();

      final deliveryTimes = DeliveryTimes(
          deliveryTimesMap: map,
          slots: deliverySlots,
          description: description);

      return ApiResponse(data: deliveryTimes);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<ApiResponse<bool>> setDeliveryTimes(
      SelectedDeliveryTime selectedDeliveryTime) async {
    final url = "${config.baseUrl}rest/V1/quote-delivery/save";
    final _body = selectedDeliveryTime.toRequestJson();
    final response = await _postResponse(url, body: _body, headers: _headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return ApiResponse(data: true);
    } else {
      final code = response.statusCode;
      throw Failure("Something went wrong ($code). Please retry!");
    }
  }

  Future<Response> _getResponse(String url, [dynamic headers]) async {
    return await _withRetry(() => httpClient.get(url, headers: headers));
  }

  Future<Response> _postResponse(String url,
      {dynamic body, dynamic headers}) async {
    return await _withRetry(() => httpClient.post(
          url,
          body: body,
          headers: headers,
        ));
  }

  Future<Response> _putResponse(String url,
      {dynamic body, dynamic headers}) async {
    return await _withRetry(() => httpClient.put(
          url,
          body: body,
          headers: headers,
        ));
  }

  Future<Response> _deleteResponse(String url, {dynamic headers}) async {
    return await _withRetry(() => httpClient.delete(
          url,
          headers: headers,
        ));
  }

  Future<Response> _withRetry(Future<Response> Function() fn) async {
    final maxRetryAttempts = 3;
    final retryDelay = 400; //millisecs
    int attempts = 0;
    while (true) {
      attempts++;
      bool canRetry = attempts <= maxRetryAttempts;
      try {
        final response = await fn();
        if (response.statusCode >= 400 && canRetry) {
          await App().init(refreshToken: true);
        } else {
          return response;
        }
      } on Exception catch (e, s) {
        if (canRetry) {
          final duration = Duration(milliseconds: (attempts) * retryDelay);
          await Future.delayed(duration);
        } else {
          if (e is SocketException) {
            throw Failure("Unable to connect to internet");
          } else {
            //Crashlytics.instance.recordError(e, s);
            throw Failure("Something went wrong. Please retry!");
          }
        }
      }
    }
  }
}
