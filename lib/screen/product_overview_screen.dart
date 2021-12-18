// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/provider/cart.dart';
import 'package:shop_app_practic_28/provider/products.dart';
import 'package:shop_app_practic_28/screen/cart_screen.dart';
import 'package:shop_app_practic_28/widget/app_drawer.dart';
import 'package:shop_app_practic_28/widget/badge.dart';
import 'package:shop_app_practic_28/widget/product_grid.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = 'overview-screen';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorite = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context, listen: false).fetchAndSetData();
    // });
    // Provider.of<Products>(context, listen: false).fetchAndSetData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('MySho5'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selecetedValue) {
                setState(() {
                  if (selecetedValue == FilterOption.Favorites) {
                    _showOnlyFavorite = true;
                  } else {
                    _showOnlyFavorite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    // ignore: prefer_const_constructors
                    PopupMenuItem(
                      child: Text('Favorites'),
                      value: FilterOption.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOption.All,
                    ),
                  ]),
          Badge(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: Icon(Icons.shopping_cart),
              ),
              title: cartItem.itemCount.toString())
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(
              showFavorite: _showOnlyFavorite,
            ),
    );
  }
}
