import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';

import '/providers/orders.dart';
import '/providers/cart.dart';
import '/providers/products.dart';
import '/providers/auth.dart';

import '/screens/error404.dart';
import '/screens/orders.dart';
import '/screens/user_products.dart';
import '/screens/product_detail.dart';
import '/screens/cart.dart';
import '/screens/products_overview.dart';
import '/screens/edit_product.dart';
import '/screens/auth.dart';
import '/screens/splash.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previous) =>
              Products(auth.token ?? '', auth.userId, previous?.items ?? []),
          create: (context) => Products('', '', []),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previous) =>
              Orders(auth.token ?? '', auth.userId, previous!.orders),
          create: (context) => Orders('', '', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              primarySwatch: Colors.blue,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          themeMode: ThemeMode.dark,
          // home: const ProductsOverviewScreen(),
          home: auth.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoSignIn(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SplashScreen();
                    }
                    return const AuthScreen();
                  },
                ),
          routes: _routes,
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => const Error404Screen(),
          ),
        ),
      ),
    );
  }

  Map<String, Widget Function(BuildContext)> get _routes => {
        ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
        CartScreen.routeName: (context) => const CartScreen(),
        OrdersScreen.routeName: (context) => const OrdersScreen(),
        UserProductsScreen.routeName: (context) => const UserProductsScreen(),
        EditProductScreen.routeName: (context) => const EditProductScreen(),
      };
}
