import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/provider/products.dart';
import 'package:shop_app_practic_28/screen/edit_product_screen.dart';

class UserItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserItem({required this.id, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      title: Text(title),
      trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id);
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () async {
                    await Provider.of<Products>(context, listen: false)
                        .deleteItem(id)
                        .catchError((error) {
                      scaffold.showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  )),
            ],
          )),
    );
  }
}
