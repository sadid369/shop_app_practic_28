import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/provider/products.dart';
import 'package:shop_app_practic_28/widget/product_item.dart';


class ProductGrid extends StatelessWidget {
  final showFavorite;
  ProductGrid({required this.showFavorite});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final product = showFavorite ? products.toggleIsFavorite : products.item;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: product.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: product[i],
        child: ProductItem(),
      ),
    );
  }
}
