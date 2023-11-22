import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user/models/address_model.dart';
import 'package:ecom_user/models/cart_model.dart';
import 'package:ecom_user/models/order_model.dart';
import 'package:ecom_user/models/product_model.dart';
import 'package:ecom_user/models/rating_model.dart';

import '../models/app_user.dart';

class DbHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionCategory = "Categories";
  static const String collectionProduct = "Products";
  static const String collectionUsers = "Users";
  static const String collectionCart = "MyCart";
  static const String collectionRating = "Ratings";
  static const String collectionOrder = "Order";

  static Future<void> addUser(AppUser user) {
    return _db.collection(collectionUsers).doc(user.id).set(user.toJson());
  }

  static Future<bool> doesUserExist(String uid) async{
    final snapshot = await _db.collection(collectionUsers).doc(uid).get();
    return snapshot.exists;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() => _db
      .collection(collectionCategory)
      .orderBy("name", descending: false)
      .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProduct() => _db
      .collection(collectionProduct)
      .where("available", isEqualTo: true)
      .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserOrders(String uid) =>
      _db.collection(collectionOrder)
      .where("appUser.id", isEqualTo: uid)
      .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserCartItems(
          String uid) =>
      _db
          .collection(collectionUsers)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();


  static Future<QuerySnapshot<Map<String, dynamic>>> getAllRatingsByProduct(String pid) =>
      _db.collection(collectionProduct)
          .doc(pid)
          .collection(collectionRating)
          .get();


  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfoById(
          String uid) =>
      _db.collection(collectionUsers).doc(uid).get();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserSnapshotInfoById(String uid) =>
      _db.collection(collectionUsers)
        .doc(uid)
        .snapshots();

  static Future<void> addToCart(String uid, CartModel cartModel) {
    return _db
        .collection(collectionUsers)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toJson());
  }

  static Future<void> addNewOrder(OrderModel orderModel) async {
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionOrder).doc(orderModel.orderId);
    wb.set(orderDoc, orderModel.toJson());
    for (final cartModel in orderModel.orderDetails) {
      final proDocSnapshot = await _db
          .collection(collectionProduct)
          .doc(cartModel.productId)
          .get();
      final currentStock = proDocSnapshot.data()!["stock"];
      final updatedStock = currentStock - cartModel.quantity;
      final proDoc =
          await _db.collection(collectionProduct).doc(cartModel.productId);
      wb.update(proDoc, {"stock": updatedStock});
    }
    final userDoc = _db.collection(collectionUsers).doc(orderModel.appUser.id);
    wb.update(userDoc, {"userAddress": orderModel.appUser.userAddress?.toJson()});

    //After Order, Delete Cart or Order page history.
    for (final cartModel in orderModel.orderDetails) {
      final cartDoc = _db.collection(collectionUsers)
          .doc(orderModel.appUser.id)
          .collection(collectionCart)
          .doc(cartModel.productId);
      wb.delete(cartDoc);
    }
    return wb.commit();
  }

  static Future<void> removeFromCart(String uid, String pid) {
    return _db
        .collection(collectionUsers)
        .doc(uid)
        .collection(collectionCart)
        .doc(pid)
        .delete();
  }

  static Future<void> updateCartQuantity(String uid, CartModel cartModel) {
    return _db
        .collection(collectionUsers)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .update(cartModel.toJson());
  }

  static Future<void> updateProductField(String pid, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(pid).update(map);
  }

  static Future<void> updateUserField(String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUsers)
        .doc(uid)
        .update(map);
  }

  static Future<void> addRating(RatingModel ratingModel, String pid) {
    return _db
        .collection(collectionProduct)
        .doc(pid)
        .collection(collectionRating)
        .doc(ratingModel.userId)
        .set(ratingModel.toJson());
  }



  //Optional cartRemove After  Order. it will not working.separate method using. show only, not use.
  //not use it's  for showing example
  static Future<void> clearCart(String uid, List<CartModel> cartList){
    final wb = _db.batch();
    for(final cartModel in cartList){
      final cartDoc = _db.collection(collectionUsers)
          .doc(uid)
          .collection(collectionCart)
          .doc(cartModel.productId);

          wb.delete(cartDoc);
    }
    return wb.commit();
  }
}
