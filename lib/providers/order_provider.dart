import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user/auth/auth_service.dart';
import 'package:ecom_user/db/db_helper.dart';
import 'package:ecom_user/models/order_model.dart';
import 'package:flutter/foundation.dart';

class OrderProvider extends ChangeNotifier{
  List<OrderModel> userOrderList=[];

  getAllUserOrders(){
    DbHelper.getAllUserOrders(AuthService.currentUser!.uid).listen((snapshot) {
      userOrderList =  List.generate(snapshot.docs.length, (index) =>
          OrderModel.fromJson(snapshot.docs[index].data()));

      notifyListeners();
    });
  }

  Future<void> addOrder(OrderModel orderModel)/*async*/{
    return /*await*/ DbHelper.addNewOrder(orderModel);

    //Optional cartRemove After  Order. it will not working.separate method showing not use
    //not use it's  for showing example
    //return DbHelper.clearCart(AuthService.currentUser!.uid, orderModel.orderDetails);
  }
}