import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/common/add_to_cart/my_add_to_cart.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/shopping_cart_icon.dart';
import 'package:vismaya/components/cart/my_cart.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/utils/utils.dart';

import 'product_bloc.dart';

class MyProductPage extends StatelessWidget {
  final Product product;

  MyProductPage(this.product);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ProductBloc()..add(OnLoadProduct(product)),
        child:
            BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
          if (state is ProductLoaded) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: config.brandColor,
                actions: <Widget>[
                  IconButton(
                      onPressed: () async {
                        //Navigate to cart
                        final route = Utils.getRoute(context, MyCartPage());
                        await Navigator.push(context, route);
                        context.bloc<ProductBloc>().add(OnLoadProduct(product));
                      },
                      icon: ShoppingCartIcon())
                ],
              ),
              backgroundColor: Colors.white,
              body: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  CachedNetworkImage(
                      imageUrl: product.getImageUrl(),
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Icon(
                            Icons.image,
                            color: Colors.grey[400],
                            size: MediaQuery.of(context).size.width,
                          )),
                  ListTile(
                    title: Text(
                      state.product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(state.product.getFormattedPrice(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[500])),
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final _variant = product.variants[index];
                        final isSelected = product.variantPosition == index;
                        final icon = isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked;
                        return Container(
                          color: isSelected ? Colors.grey[300] : Colors.white,
                          child: ListTile(
                            leading: Icon(
                              icon,
                              color: config.brandColor,
                            ),
                            title: Row(
                              children: <Widget>[
                                Text(
                                  _variant.getSize(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(" - "),
                                Utils.displayPriceInfo(_variant)
                              ],
                            ),
                            onTap: () {
                              state.product.variantPosition = index;
                              context
                                  .bloc<ProductBloc>()
                                  .add(OnPackSizeClicked(state.product));
                            },
                          ),
                        );
                      },
                      itemCount: product.variants.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(product.getDescription()),
                  )
                ],
              ),
              bottomNavigationBar: SafeArea(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyAddToCartButton(
                    product.getCurrentVariant(),
                    inProductList: false,
                  ),
                ],
              )),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: config.brandColor,
            ),
            body: ProgressIndicatorWidget(),
          );
        }));
  }
}
