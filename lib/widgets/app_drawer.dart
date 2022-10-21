import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders.dart';

import '../screens/user_products.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget _buildScreenItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String routeName,
  }) =>
      ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () => Navigator.of(context).pushReplacementNamed(routeName),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Home'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          _buildScreenItem(
            context: context,
            icon: Icons.shop,
            title: 'Shop',
            routeName: '/',
          ),
          _buildScreenItem(
            context: context,
            icon: Icons.payment,
            title: 'Orders',
            routeName: OrdersScreen.routeName,
          ),
          _buildScreenItem(
            context: context,
            icon: Icons.edit,
            title: 'Manage Products',
            routeName: UserProductsScreen.routeName,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Navigator.of(context).pop();
              Scaffold.of(context).closeDrawer();
              Navigator.of(context).pushReplacementNamed('/');

              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
