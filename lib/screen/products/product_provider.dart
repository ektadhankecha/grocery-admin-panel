import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_admin_panel/model/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final CollectionReference productCollection = FirebaseFirestore.instance.collection("products");
  List<ProductModel> products = [];
  ProductProvider(){
    fetchProducts();
  }
  void fetchProducts(){
    productCollection.snapshots().listen(
        (snapshot){
          products = snapshot.docs.map((doc){
            return ProductModel.fromFirestore(
                doc.data() as Map<String , dynamic>,
                doc.id);
          }).toList();
          notifyListeners();
        },
    );
  }

  Future<void> addProduct({
    required String productId,
    required String name,
    required String category,
    required String image,
    required Color bgColor,
    required String stock,
    required String price,
    required String quantity,
    required String description,
  }) async{
    await productCollection.add({
      'productId' :productId,
      'name' : name,
      'category' : category,
      'image' : image,
      'bgColor' : bgColor.toARGB32(),
      'stock' : stock,
      'price' : price,
      'quantity' : quantity,
      'description' : description
    });
  }

  Future<void> updateProduct({
    required String id,
    required String productId,
    required String name,
    required String category,
    required String image,
    required Color bgColor,
    required String stock,
    required String price,
    required String quantity,
    required String description,
  }) async{
    await productCollection.doc(id).update({
      'productId' : productId,
      'name' : name,
      'category' : category,
      'image' : image,
      'bgColor' : bgColor.toARGB32(),
      'stock' : stock,
      'price' : price,
      'quantity' : quantity,
      'description' : description
    });
  }

  Future<void> deleteProduct(String id) async {
    await productCollection.doc(id).delete();
  }
}