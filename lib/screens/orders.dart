import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() =>
      Provider.of<Orders>(context, listen: false).fetchOrders();

  @override
  void initState() {
    super.initState();
    _ordersFuture = _obtainOrdersFuture();
  }

  @override
  Widget build(BuildContext context) {
    print('OrdersScreen build called');
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.error != null || snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return Consumer<Orders>(
            builder: (context, ordersData, child) =>
                ordersData.orders.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) =>
                            OrderItem(ordersData.orders[index]),
                        itemCount: ordersData.itemCount,
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('No orders'),
                            ElevatedButton(
                              onPressed: ordersData.fetchOrders,
                              child: const Text('Refresh'),
                            ),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }
}
