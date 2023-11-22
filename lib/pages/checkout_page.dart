import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user/models/address_model.dart';
import 'package:ecom_user/models/app_user.dart';
import 'package:ecom_user/models/order_model.dart';
import 'package:ecom_user/pages/order_successful_page.dart';
import 'package:ecom_user/pages/product_list_page.dart';
import 'package:ecom_user/providers/cart_provider.dart';
import 'package:ecom_user/providers/order_provider.dart';
import 'package:ecom_user/utils/helper_functions.dart';
import 'package:ecom_user/utils/widget_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/constants.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = "/checkout";

  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CartProvider cartProvider;
  late UserProvider userProvider;
  late AppUser appUser;
  String? city;
  final _formKey = GlobalKey<FormState>();
  final AddressController = TextEditingController();
  final ZipCodeController = TextEditingController();

  @override
  void didChangeDependencies() {
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _getUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Order"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
              elevation: 8.0,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("Items",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    )),
              )),
          Card(
            child: Column(
              children: cartProvider.cartList
                  .map((cartModel) => ListTile(
                        title: Text(cartModel.productName,
                            style: const TextStyle(fontSize: 20)),
                        trailing: Text(
                          "${cartModel.quantity}x${cartModel.price}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Amount:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("$currencySymbol${cartProvider.getSubTotal()}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Card(
              elevation: 6.0,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("Delivery Address",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    )),
              )),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      items: cities
                          .map((city) => DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          city = value;
                        });
                      },
                      value: city,
                      hint: const Text("Select City"),
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This Field Must Not Be Empty";
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        controller: AddressController,
                        decoration: InputDecoration(
                          labelText: "Street Address",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This Field Must Not Be Empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        controller: ZipCodeController,
                        decoration: InputDecoration(
                          labelText: "Zip Code",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This Field Must Not Be Empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _saveOrder,
                      child: const Text("PLACE ORDER"),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    AddressController.dispose();
    ZipCodeController.dispose();
    super.dispose();
  }

  void _getUser() async {
    appUser = await UserProvider().getUser();
    if (appUser.userAddress != null) {
      setState(() {
        city = appUser.userAddress!.city;
        AddressController.text = appUser.userAddress!.streetAddress;
        ZipCodeController.text = appUser.userAddress!.zipCode;
      });
    }
  }

  void _saveOrder() async {
    if (_formKey.currentState!.validate()) {
      final address = AddressModel(
          streetAddress: AddressController.text,
          city: city!,
          zipCode: ZipCodeController.text);
      appUser.userAddress = address;
      final orderModel = OrderModel(
        orderId: genarateOrderId,
        appUser: appUser,
        totalAmount: cartProvider.getSubTotal(),
        orderStatus: orderStatus.pending,
        orderDetails: cartProvider.cartList,
        orderDateTime: Timestamp.fromDate(DateTime.now()),
      );
      EasyLoading.show(status: "Please Wait");
      Provider.of<OrderProvider>(context, listen: false)
          .addOrder(orderModel)
          .then((value) {
        EasyLoading.dismiss();
        showMsg(context, "Oder Saved");
        
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderSuccessfulPage()),
            ModalRoute.withName(ProductListPage.routeName));

      }).catchError((error) {
        EasyLoading.dismiss();
        showMsg(context, error.toString());
      });
    }
  }
}
