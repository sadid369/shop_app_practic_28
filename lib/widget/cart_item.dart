import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/provider/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productKey;
  final double price;
  final int quantity;
  final String title;
  const CartItemWidget({
    Key? key,
    required this.id,
    required this.productKey,
    required this.price,
    required this.quantity,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('it will remove the item?'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text('no'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text(
                      'yes',
                    ),
                  )
                ],
              );
            });
      },
      background: Container(
        color: Theme.of(context).errorColor,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(8),
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),
      onDismissed: (value) {
        Provider.of<Cart>(context, listen: false).removeItem(productKey);
      },
      key: ValueKey(id),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  '\$${price}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          title: Text(title),
          subtitle: Text('\$${price * quantity}'),
          trailing: Text('$quantity X'),
        ),
      ),
    );
  }
}
