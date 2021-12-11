import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/provider/products.dart';
import 'package:shop_app_practic_28/screen/edit_product_screen.dart';
import 'package:shop_app_practic_28/widget/app_drawer.dart';
import 'package:shop_app_practic_28/widget/user_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'user-screen';
  Future<void> refereshData(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndSetData();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
        title: Text('Edit Product'),
      ),
      body: RefreshIndicator(
        onRefresh: () => refereshData(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productData.item.length,
            itemBuilder: (ctx, i) => Column(
              children: [
                UserItem(
                  id: productData.item[i].id!,
                  title: productData.item[i].title,
                  imageUrl: productData.item[i].imageUrl,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
