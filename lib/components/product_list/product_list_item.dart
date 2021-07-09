import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vismaya/common/add_to_cart/my_add_to_cart.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/utils/utils.dart';

class ProductListItem extends StatelessWidget {
  final position;
  final Product product;
  final ValueChanged<int> onVariantPositionChanged;
  final VoidCallback onTap;
  const ProductListItem(this.product, this.position,
      {this.onVariantPositionChanged, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasMoreVariants = product.variants.length > 1;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(8),
      title: Row(
        children: [
          CachedNetworkImage(
              imageUrl: product.getImageUrl(),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Icon(
                    Icons.image,
                    color: Colors.grey[400],
                    size: 80,
                  )),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(product.getBrand(), style: TextStyle(fontSize: 12)),
                SizedBox(
                  height: 5,
                ),
                Text(
                  product.name,
                  style: TextStyle(fontSize: 14),
                ),
                Utils.displayPriceInfo(product.getCurrentVariant()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: !hasMoreVariants
                          ? null
                          : () => _showVariantPicker(context, product),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300], width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(product.getSize()),
                            Visibility(
                                visible: hasMoreVariants,
                                child: Icon(Icons.expand_more))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: MyAddToCartButton(product.getCurrentVariant()),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showVariantPicker(BuildContext context, Product product) async {
    final _variants = product.variants;
    if (_variants.length < 2) return;
    final index = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(10, 16, 10, 0),
            title: Column(
              children: <Widget>[
                Text(
                  "Avaliable quantities for",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${product.getBrand()} - ${product.name}",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: _variants.length,
                itemBuilder: (context, index) {
                  final _variant = _variants[index];
                  bool _isSelected = index == product.variantPosition;
                  return Container(
                    color: _isSelected ? Colors.grey[300] : Colors.white,
                    child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Text(
                              _variant.getSize(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("  —  "),
                            Utils.displayPriceInfo(_variant)
                          ],
                        ),
                        onTap: () => Navigator.of(context).pop(index)),
                  );
                },
              ),
            ),
          );
        });
    if (index != null) {
      onVariantPositionChanged(index);
    }
  }
}
