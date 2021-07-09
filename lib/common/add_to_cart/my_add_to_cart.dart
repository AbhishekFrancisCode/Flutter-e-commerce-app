import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/product_variant.dart';
import 'package:vismaya/utils/utils.dart';

import 'add_to_cart_bloc.dart';

class MyAddToCartButton extends StatelessWidget {
  final ProductVariant variant;
  final bool inProductList;

  MyAddToCartButton(this.variant, {this.inProductList = true});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddToCartBloc()..add(OnLoadAddToCart(variant.sku)),
      child:
          BlocBuilder<AddToCartBloc, AddToCartState>(builder: (context, state) {
        if (state is AddToCartLoaded) {
          if (state.errorMessage.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Utils.showAlertDialog(context, "Error", state.errorMessage);
            });
          }
          final sku = variant.sku;
          final _quantity = config.cart.getCartItemBySku(sku)?.qty ?? 0;
          final _fontSize = inProductList ? 16.0 : 18.0;
          final _textStyle = TextStyle(fontSize: _fontSize);
          return _quantity == 0
              ? RaisedButton(
                  textColor: Colors.white,
                  color: config.brandColor,
                  child: Text(
                    inProductList ? "Add" : "Add to basket",
                    style: _textStyle,
                  ),
                  onPressed: () => context
                      .bloc<AddToCartBloc>()
                      .add(OnAddToCartPressed(sku)))
              : Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 8),
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        child: FloatingActionButton(
                          elevation: 0,
                          mini: true,
                          heroTag: null,
                          backgroundColor: config.brandColor,
                          child: Icon(Icons.remove),
                          onPressed: () => context
                              .bloc<AddToCartBloc>()
                              .add(OnQuantityChanged(sku, -1)),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          _quantity.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        child: FloatingActionButton(
                          elevation: 0,
                          mini: true,
                          heroTag: null,
                          backgroundColor: config.brandColor,
                          child: Icon(Icons.add),
                          onPressed: () => context
                              .bloc<AddToCartBloc>()
                              .add(OnQuantityChanged(sku, 1)),
                        ),
                      ),
                    ],
                  ),
                );
        }
        return Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          width: 100,
          height: 50,
          alignment: Alignment.center,
          child: SizedBox(
              height: 25, width: 25, child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
