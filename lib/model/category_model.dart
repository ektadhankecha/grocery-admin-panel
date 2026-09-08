import 'dart:typed_data';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
 final String image;
  final String name;
  final Color bgColor;
  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.bgColor,
  });

  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      bgColor: Color(data['bgColor']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'image': image,
      'bgColor': bgColor.toARGB32(),
    };
  }
}
