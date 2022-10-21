import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product.dart';

import '/providers/products.dart';
import '/widgets/user_product_item.dart';
import '/widgets/app_drawer.dart';

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({super.key});

  static const routeName = '/userProducts';

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  final _refresh = GlobalKey<RefreshIndicatorState>();

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) => _refresh.currentState?.show(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
        key: _refresh,
        onRefresh: () => _refreshProducts(context),
        child: Consumer<Products>(
          builder: (context, products, child) => Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  UserProductItem(products.items[index]),
              itemCount: products.itemCount,
            ),
          ),
        ),
      ),
    );
  }
}
