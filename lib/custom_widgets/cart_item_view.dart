import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user/models/cart_model.dart';
import 'package:ecom_user/providers/cart_provider.dart';
import 'package:ecom_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemView extends StatelessWidget {
  final CartModel cartmodel;

  const CartItemView({super.key, required this.cartmodel});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              width: 100,
              height: 100,
              child: CachedNetworkImage(
                fadeInDuration: const Duration(seconds: 2),
                fadeInCurve: Curves.easeInOut,
                imageUrl: cartmodel.imageUrl,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
            title: Text(cartmodel.productName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$currencySymbol${cartmodel.price}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      cartProvider.decreaseQuantity(cartmodel);
                    },
                    icon: const Icon(Icons.remove_rounded),
                    iconSize: 30,
                  ),
                  Text(
                    "${cartmodel.quantity}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () {
                      cartProvider.increaseQuantity(cartmodel);
                    },
                    icon: const Icon(Icons.add_rounded),
                    iconSize: 30,
                  ),

                ],
              ),

              Text(
                "$currencySymbol${cartProvider.priceWithQuantity(cartmodel.price, cartmodel.quantity)}",
                style: const TextStyle(fontSize: 18),
              ),
              IconButton(
                  onPressed: (){
                    cartProvider.removeFromCart(cartmodel.productId);
                  },
                  icon: const Icon(Icons.delete),
              )
            ],
          )
        ],
      ),
    );
  }
}
