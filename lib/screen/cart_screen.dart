// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/provider/cart.dart';
import 'package:shop_app_practic_28/provider/order.dart';
import 'package:shop_app_practic_28/widget/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart-screen';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(fontSize: 20),
                      ),
                      Chip(
                        label: Text(
                          cartData.itemTotal.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 15,
                        shadowColor: Theme.of(context).colorScheme.secondary,
                      ),
                      OrderButton(cartData: cartData),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: cartData.itemCount,
                  itemBuilder: (ctx, i) => CartItemWidget(
                        id: cartData.cartItems.values.toList()[i].id,
                        productKey: cartData.cartItems.keys.toList()[i],
                        price: cartData.cartItems.values.toList()[i].price,
                        quantity:
                            cartData.cartItems.values.toList()[i].quantity,
                        title: cartData.cartItems.values.toList()[i].title,
                      )),
            ),
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      disabledTextColor: Colors.grey,
      textColor: Colors.purple,
      onPressed: (widget.cartData.itemTotal <= 0)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Order>(context, listen: false)
                  .addItems(widget.cartData.cartItems.values.toList(),
                      widget.cartData.itemTotal)
                  .then((_) {
                setState(() {
                  _isLoading = false;
                });
                widget.cartData.clear();
              }).catchError((error) {
                print(error.toString());
              });
            },
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text(
              'Order Now',
            ),
    );
  }
}
