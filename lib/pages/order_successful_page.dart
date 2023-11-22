import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatelessWidget {
  static const String routeName ="/successful";
  const OrderSuccessfulPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Placed"),),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.done, size: 100,color: Colors.amber,),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Your Order has been placed", style: TextStyle(fontSize: 20, color: Colors.green),),
            )
          ],
        ),
      ),
    );
  }
}
