import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart.dart';
import '../widgets/app_drawer.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

// ignore: constant_identifier_names
enum FilterOption { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  // static const routeName = '/products';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption value) {
              setState(() {
                switch (value) {
                  case FilterOption.All:
                    _showFavoritesOnly = false;
                    break;
                  case FilterOption.Favorites:
                    _showFavoritesOnly = true;
                    break;
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FilterOption.Favorites,
                child: Text('Only favorites'),
              ),
              const PopupMenuItem(
                value: FilterOption.All,
                child: Text('Show all'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          // IconButton(
          //   onPressed: () =>
          //       Navigator.of(context).pushNamed(OrdersScreen.routeName),
          //   icon: const Icon(Icons.mail),
          // ),
          Consumer<Cart>(
            builder: (ctx, value, child) => Badge(
              value: '${value.itemCount}',
              child: child ?? const SizedBox.shrink(),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.pushNamed(context, CartScreen.routeName),
            ),
          ),
        ],
        title: const Text('App'),
      ),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }
}
