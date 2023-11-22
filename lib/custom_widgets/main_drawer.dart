import 'package:ecom_user/auth/auth_service.dart';
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
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.purple.shade600,
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, UserProfilePage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text("My Profile"),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
            },
            leading: const Icon(Icons.shopping_cart),
            title: const Text("My Cart"),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, UserOrderPage.routeName);
            },
            leading: const Icon(Icons.bookmark_border),
            title: const Text("My Orders"),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              AuthService.logOut().then((value) => Navigator.pushReplacementNamed(context, LauncherScreen.routeName));
            },
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
