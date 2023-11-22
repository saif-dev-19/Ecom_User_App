import 'package:ecom_user/auth/auth_service.dart';
import 'package:ecom_user/db/db_helper.dart';
import 'package:ecom_user/models/product_model.dart';
import 'package:flutter/foundation.dart';

import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier{

  List<CartModel> cartList = [];

  int get totalCartInList => cartList.length;

  Future<void> addToCart(ProductModel productModel, num priceAfterDiscount){
    final cartModel = CartModel(
        productId: productModel.id!,
        productName: productModel.name,
        imageUrl: productModel.imageUrl,
        price: priceAfterDiscount,
    );
    return DbHelper.addToCart(AuthService.currentUser!.uid, cartModel);
  }

  Future<void> removeFromCart(String pid){
    return DbHelper.removeFromCart(AuthService.currentUser!.uid, pid);
  }


  getAllUserCartItems(){
    DbHelper.getAllUserCartItems(AuthService.currentUser!.uid).listen((snapshot) {
      cartList =  List.generate(snapshot.docs.length, (index) =>
          CartModel.fromJson(snapshot.docs[index].data()));

      notifyListeners();
    });
  }



  bool isInCart(String pid){
    bool tag = false;
    for(final cart in cartList){
      if(cart.productId == pid){
        tag = true;
        break;
      }
    }
    return tag;
  }

  num priceWithQuantity (num price, num quantity) => price * quantity;

  Future<void>increaseQuantity(CartModel cartModel){
    cartModel.quantity += 1;
    return DbHelper.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
  }

  Future<void>decreaseQuantity(CartModel cartModel)async{
    if(cartModel.quantity > 1){
      cartModel.quantity -= 1;
      return DbHelper.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
    }
  }

  num getSubTotal(){
    num total = 0;

    for(final cart in cartList){
      total += priceWithQuantity(cart.price, cart.quantity);
    }
    return total;
  }
}