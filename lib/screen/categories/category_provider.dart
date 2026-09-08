import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/model/category_model.dart';
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

  Future<void> deleteCategory(String id) async {
    await categoryCollection.doc(id).delete();
  }

  int getProductCount(String categoryName) {
    final catName = categoryName.trim().toLowerCase();
    return ProductProvider().products.where((p) {
      final pCat = p.category.trim().toLowerCase();
      return pCat == catName ||
          pCat.contains(catName) ||
          catName.contains(pCat);
    }).length;
  }
}
