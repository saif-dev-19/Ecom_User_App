import 'package:ecom_user/custom_widgets/cart_badge_view.dart';
import 'package:ecom_user/custom_widgets/main_drawer.dart';
import 'package:ecom_user/providers/cart_provider.dart';
import 'package:ecom_user/providers/order_provider.dart';
import 'package:ecom_user/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/grid_product_item.dart';
import '../providers/product_provider.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = "/products";
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<CartProvider>(context, listen: false).getAllUserCartItems();
    Provider.of<OrderProvider>(context, listen: false).getAllUserOrders();
    Provider.of<UserProvider>(context, listen: false).getUserSnapshot();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text("Products"),
        actions: [
         const CartBadgeView(),
        ],
      ),
      body:Container(
        decoration: BoxDecoration(
          //color: Colors.teal,
        ),
        child: Consumer<ProductProvider>(
          builder: (context, provider, child) => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
              ),
            itemCount: provider.productList.length,
            itemBuilder: (context, index) {
              final product = provider.productList[index];
              return GridProductItem(product: product);
            },
          ),
        ),
      ),
    );
  }
}
