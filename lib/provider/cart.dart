import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final double price;
  final int quantity;
  final String title;
  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};
  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  void addCartItem(String productId, double price, String title) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (exixtingProduct) => CartItem(
              id: exixtingProduct.id,
              price: exixtingProduct.price,
              quantity: exixtingProduct.quantity + 1,
              title: exixtingProduct.title));
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              quantity: 1,
              title: title));
    }
    notifyListeners();
  }

  int get itemCount {
    return _cartItems.length;
  }

  double get itemTotal {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void removeItem(String productKey) {
    _cartItems.remove(productKey);
    notifyListeners();
  }

  void singleItemRemove(String id) {
    if (!_cartItems.containsKey(id)) {
      return;
    }
    if (_cartItems[id]!.quantity > 1) {
      _cartItems.update(
          id,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1,
              title: existingCartItem.title));
    } else {
      _cartItems.remove(id);
    }
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }
}
