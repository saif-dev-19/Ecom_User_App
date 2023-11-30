import 'package:ecom_user/auth/auth_service.dart';
import 'package:ecom_user/pages/cart_page.dart';
import 'package:ecom_user/pages/launcher_screen.dart';
import 'package:ecom_user/pages/login_screen.dart';
import 'package:ecom_user/pages/user_order_page.dart';
import 'package:ecom_user/pages/user_profile_page.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.orangeAccent.shade200,
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.orange.shade700,
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, UserProfilePage.routeName);
            },
            leading: const Icon(Icons.person,color: Colors.brown),
            title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, CartPage.routeName);
            },
            leading: const Icon(Icons.shopping_cart,color: Colors.brown),
            title: const Text("My Cart",style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, UserOrderPage.routeName);
            },
            leading: const Icon(Icons.bookmark_border,color: Colors.brown),
            title: const Text("My Orders",style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              AuthService.logOut().then((value) => Navigator.pushReplacementNamed(context, LauncherScreen.routeName));
            },
            leading: const Icon(Icons.logout,color: Colors.brown,),
            title: const Text("Logout",style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
