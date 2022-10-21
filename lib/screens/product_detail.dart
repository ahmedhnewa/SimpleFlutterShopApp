import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

import '../providers/auth.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  static const routeName = '/productDetail';

  @override
  Widget build(BuildContext context) {
    print('ProductDetail get called');
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // title: Text(product.title),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Text(
                  '\$${product.price}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 800)
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FavoriteButton(product: product),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          final auth = Provider.of<Auth>(context, listen: false);
          widget.product.toggleFavorite(auth.token!, auth.userId);
        });
      },
      child: Icon(
          widget.product.isFavorite ? Icons.favorite : Icons.favorite_border),
    );
  }
}
