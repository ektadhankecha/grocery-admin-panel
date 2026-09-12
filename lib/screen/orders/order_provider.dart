import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/model/order_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderProvider() {
    listenToOrder();
  }
  List<OrderModel> orderList = [];
  void listenToOrder() {
    FirebaseFirestore.instance.collection("Orders").orderBy("orderNumber", descending: true).snapshots().listen((snapshot) {
      final List<OrderModel> loadedOrders = [];
      for (var doc in snapshot.docs) {
        try {
          if (doc.data().isNotEmpty) {
            loadedOrders.add(OrderModel.fromMap(doc.data(), doc.id));
          }
        } catch (e) {
          debugPrint("Error parsing order doc ${doc.id}: $e");

        }
      }
      orderList = loadedOrders;
      notifyListeners();
    }, onError: (error) {
      debugPrint("Firestore Order Stream Error: $error");
    });
  }
  Future<void> updateOrderStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(docId)
          .update({'status': newStatus});
    } catch (e) {
      debugPrint("Error updating order status: $e");
    }
  }
}
