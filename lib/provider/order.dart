import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app_practic_28/provider/cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> cartItems;
  final DateTime dateTime;
  final double amount;
  OrderItem({
    required this.id,
    required this.cartItems,
    required this.dateTime,
    required this.amount,
  });
}

class Order with ChangeNotifier {
  String? authToken;
  String? userId;
  Order(this.authToken, this._orderItems, this.userId);
  List<OrderItem> _orderItems = [];
  List<OrderItem> get orderItems {
    return [..._orderItems];
  }

  Future<void> fetchAndSetData() async {
    final url =
        'https://shop-app-practic-2-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    await http.get(Uri.parse(url)).then((response) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<OrderItem> loadedData = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedData.add(OrderItem(
            id: prodId,
            cartItems: (prodData['cartItems'] as List<dynamic>)
                .map((items) => CartItem(
                    id: items['id'],
                    price: items['price'],
                    quantity: items['quantity'],
                    title: items['title']))
                .toList(),
            dateTime: DateTime.parse(prodData['dateTime']),
            amount: prodData['amount']));
      });
      _orderItems = loadedData.reversed.toList();
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> addItems(List<CartItem> cartItem, double amount) async {
    final url =
        'https://shop-app-practic-2-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final dateTimeStamp = DateTime.now();
    await http
        .post(Uri.parse(url),
            body: json.encode({
              'amount': amount,
              'dateTime': dateTimeStamp.toIso8601String(),
              'cartItems': cartItem
                  .map((cp) => {
                        'id': cp.id,
                        'title': cp.title,
                        'quantity': cp.quantity,
                        'price': cp.price
                      })
                  .toList(),
            }))
        .then((response) {
      _orderItems.insert(
          0,
          OrderItem(
              amount: amount,
              id: DateTime.now().toString(),
              dateTime: dateTimeStamp,
              cartItems: cartItem));
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }
}
