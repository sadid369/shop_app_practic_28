import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/provider/order.dart';
import 'package:shop_app_practic_28/widget/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = 'order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        setState(() {
          _isLoading = true;
        });
      });
      await Provider.of<Order>(context, listen: false).fetchAndSetData();
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Order'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: orderData.orderItems.length,
                itemBuilder: (ctx, i) =>
                    OrderItemWidget(order: orderData.orderItems[i]),
              ));
  }
}
