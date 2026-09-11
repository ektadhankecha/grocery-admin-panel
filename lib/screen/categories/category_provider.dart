import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/model/category_model.dart';
import 'package:grocery_admin_panel/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_admin_panel/screen/products/product_provider.dart';
import 'package:grocery_admin_panel/screen/products/product_data.dart';

class CategoryProvider extends ChangeNotifier {
  final CollectionReference categoryCollection = FirebaseFirestore.instance
      .collection("categories");

  List<CategoryModel> categories = [];
  CategoryProvider() {
    fetchCategories();
  }

  void fetchCategories() {
    categoryCollection.snapshots().listen(
      (snapshot) {
        categories = snapshot.docs.map((doc) {
          return CategoryModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();
        notifyListeners();
      },
      onError: (error) {
        debugPrint("Error fetching categories: $error");
      },
    );
  }

  Future<void> addCategory({
    required String name,
    required Color bgColor,
    required String image,
  }) async {
    await categoryCollection.add({
      'name': name,
      'image': image,
      'bgColor': bgColor.toARGB32(),
    });
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String image,
    required Color bgColor,
  }) async {
    await categoryCollection.doc(id).update({
      'name': name,
      'image': image,
      'bgColor': bgColor.toARGB32(),
    });
  }

  Future<void> deleteCategory(String id, String categoryName) async {
 //   await categoryCollection.doc(id).delete();
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();
    final productSnapshot = await firestore.collection("products").where("category", isEqualTo: categoryName).get();
    for (var doc in productSnapshot.docs){
      batch.delete(doc.reference);
    }
    batch.delete(categoryCollection.doc(id));
    await batch.commit();
  }

  int getProductCount(String categoryName, List<ProductModel> products) {
    final catName = categoryName.trim().toLowerCase();
    return products.where((p) {
      final pCat = p.category.trim().toLowerCase();
      return pCat == catName ||
          pCat.contains(catName) ||
          catName.contains(pCat);
    }).length;
  }
}
