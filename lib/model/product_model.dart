import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String image;
  final Color bgColor;
  final String stock;
  final String price;
  final String quantity;
  final String? description;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.bgColor,
    required this.stock,
    required this.price,
    required this.quantity,
    required this.description,
  });
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      bgColor: data["bgColor"] != null ? Color(data["bgColor"]) : Colors.white,
      stock: data["stock"] ?? '',
      price: data['price'] ?? '',
      quantity: data['quantity'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'image': image,
      'bgColor': bgColor.toARGB32(),
      'stock': stock,
      'price': price,
      'quantity': quantity,
      'description': description,
    };
  }
}
