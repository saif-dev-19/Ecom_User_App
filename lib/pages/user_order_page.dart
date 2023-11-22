import 'package:ecom_user/providers/order_provider.dart';
import 'package:ecom_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserOrderPage extends StatelessWidget {
  static const String routeName = "/userorder";
  const UserOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders"),),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.userOrderList.length,
          itemBuilder: (context, index) {
            final order = provider.userOrderList[index];
            return ListTile(
              title: Text(order.orderId),
              subtitle: Text("$currencySymbol${order.totalAmount}"),
              trailing: Text(order.orderStatus),
            );
          }
        ),
      ),
    );
  }
}
