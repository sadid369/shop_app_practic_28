import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/provider/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product Detail Screen';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productData =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
        appBar: AppBar(
          title: Text(productData.title),
        ),
        body: Column(
          children: [
            Container(
              child: Image.network(
                productData.imageUrl,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('\$${productData.price}'),
            SizedBox(
              height: 10,
            ),
            Text(
              productData.description,
            ),
          ],
        ));
  }
}
