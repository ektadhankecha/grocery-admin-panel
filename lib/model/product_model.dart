import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProductModel {
  final int id;
  final String name;
  final String category;
  final String? image;
  final Uint8List? imageBytes;
  final Color bgColor;
  final String stock;
  final String price;
  final String quantity;
  final String? description;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    this.image,
    this.imageBytes,
    required this.bgColor,
    required this.stock,
    required this.price,
    required this.quantity,
    this.description,
  });
}
