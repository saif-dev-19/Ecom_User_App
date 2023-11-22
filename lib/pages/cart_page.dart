import 'package:ecom_user/pages/checkout_page.dart';
import 'package:ecom_user/providers/cart_provider.dart';
import 'package:ecom_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/cart_item_view.dart';

class CartPage extends StatelessWidget {
  static const String routeName = "/cart";

  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) =>

        provider.totalCartInList == 0 ? const Center(child:Text("No Item in Cart"),) :
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartModel = provider.cartList[index];
                  return CartItemView(cartmodel: cartModel);
                },
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SUB TOTAL: $currencySymbol${provider.getSubTotal()}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    TextButton(
                      onPressed:() => Navigator.pushNamed(context, CheckoutPage.routeName),
                      child: const Text("CHECKOUT",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
