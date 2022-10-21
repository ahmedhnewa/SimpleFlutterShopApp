import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../providers/products.dart';
import '/providers/cart.dart';
import '/providers/auth.dart';
import '../providers/product.dart';
import '/screens/product_detail.dart';
import '/constants/assets.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    print('ProductItem build called');
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    const double radius = 10;
    final borderRadius = BorderRadius.circular(radius);
    return ClipRRect(
      borderRadius: borderRadius,
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          subtitle: Text('\$${product.price}'),
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              onPressed: () {
                final auth = Provider.of<Auth>(context, listen: false);
                product.toggleFavorite(auth.token!, auth.userId);
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(productId: product.id);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Added item to the cart!'),
                action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    }),
              ));
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.start,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage(Assets.assetsImagesProductPlaceholder),
              fit: BoxFit.cover,
              image: NetworkImage(product.imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
