import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatefulWidget {
  ProductsGrid(this.showFavoritesOnly, {Key? key}) : super(key: key);
  final bool showFavoritesOnly;

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  final _refresh = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      _refresh.currentState!.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = widget.showFavoritesOnly
        ? productsData.favoritesItems
        : productsData.items;
    return RefreshIndicator(
      onRefresh: () async {
        await productsData.fetchProducts();
      },
      key: _refresh,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: const ProductItem(),
        ),
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
      ),
    );
  }
}
