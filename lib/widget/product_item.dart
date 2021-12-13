import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/provider/auth.dart';
import 'package:shop_app_practic_28/provider/cart.dart';
import 'package:shop_app_practic_28/provider/products.dart';
import 'package:shop_app_practic_28/screen/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Product>(context, listen: true);
    final cartItem = Provider.of<Cart>(context);
    final authToken = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            products.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: products.id);
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          title: Text(products.title),
          leading: IconButton(
            icon: Icon(
                products.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () async {
              await products
                  .toggleIsFavorite(authToken.token!)
                  .catchError((error) {
                print(error.toString());
              });
            },
          ),
          trailing: IconButton(
            onPressed: () {
              cartItem.addCartItem(
                  products.id!, products.price, products.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cartItem.singleItemRemove(products.id!);
                    },
                  ),
                  duration: Duration(seconds: 2),
                  content: Text(
                    'item Added to Cart',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ),
      ),
    );
  }
}
