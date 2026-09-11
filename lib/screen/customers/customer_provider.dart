import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_admin_panel/model/customer_model.dart';

class CustomerProvider extends ChangeNotifier {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users"); // or "customers"

  List<CustomerModel> customers = [];
  bool isLoading = true;

  CustomerProvider() {
    fetchCustomers();
  }

  void fetchCustomers() {
    isLoading = true;
    notifyListeners();

    userCollection.snapshots().listen(
      (snapshot) {
        final List<CustomerModel> loadedCustomers = [];
        for (var doc in snapshot.docs) {
          try {
            if (doc.data() != null) {
              loadedCustomers.add(
                CustomerModel.fromFireStore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              );
            }
          } catch (e) {
            debugPrint("Error parsing customer doc ${doc.id}: $e");
          }
        }
        customers = loadedCustomers;
        isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        debugPrint("Firestore Customer Stream Error: $error");
        isLoading = false;
        notifyListeners();
      },
    );
  }
}