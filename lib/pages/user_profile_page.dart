import 'package:ecom_user/providers/user_provider.dart';
import 'package:ecom_user/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  static const String routeName ="/profile";
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile"),),
      body: Consumer<UserProvider>(
        builder:(context, provider, child) =>ListView(
          children: [
              buildProfileCover(provider),
            ListTile(
              title: Text("Display Name : ${provider.appUser?.displayName ?? "No Name Found"}",
                style: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),),
              trailing: IconButton(
                onPressed: (){
                  showSigleTextInputDialog(
                      context: context,
                      title: "Edit Name",
                      onSave: (value)async{
                         await provider.updateUserFieldName(value);
                      });
                },
                icon: Icon(Icons.edit),
              ),
            ),
            ListTile(
              title: Text("Phone Number : ${provider.appUser?.phoneNumber ?? "No Number Found"}",
                style: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),),

              trailing: IconButton(
                onPressed: (){
                  showSigleTextInputDialog(
                      context: context,
                      title: "Edit Number",
                      onSave: (value)async{
                        await provider.updateUserFieldNumber(value);
                      });
                },
                icon: Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildProfileCover(UserProvider provider) {
    return SizedBox(
              height: 150,
                child: Card(
                  color: Colors.purple.shade300,
                  child: Center(
                    child: Row(
                      children: [
                        const Icon(Icons.person_rounded, size: 100,),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(provider.appUser?.displayName ?? "User Not Yet Set",style: TextStyle(fontSize: 18),),
                            Text(provider.appUser?.email ?? "User Not Yet Set",style: TextStyle(fontSize: 18),),
                            Text(provider.appUser?.phoneNumber ?? "User Not Yet Set",style: TextStyle(fontSize: 18),),
                          ],
                        )
                      ],
                    ),

                  ),
                ));
  }
}
