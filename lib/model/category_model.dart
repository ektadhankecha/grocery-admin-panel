import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Model representing a product category
class CategoryModel {
  final int? id;
  final String name;
  final String image;
  final Uint8List? imageBytes;
  final Color bgColor;
  final Color foregroundColor;

  const CategoryModel({
    this.id,
    required this.name,
    this.image = '',
    this.imageBytes,
    required this.bgColor,
    required this.foregroundColor,
  });
}
