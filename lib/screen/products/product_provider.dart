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

  Future<void> addProduct(ProductModel product) async{
    await productCollection.add(product.toFirestore());
  }

  Future<void> updateProduct(ProductModel product) async{
    await productCollection.doc(product.id).update(product.toFirestore());
  }

  Future<void> deleteProduct(String id) async {
    await productCollection.doc(id).delete();
  }
}