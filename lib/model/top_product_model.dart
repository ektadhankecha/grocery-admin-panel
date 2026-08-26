import 'package:flutter/material.dart';

class TopProductModel {
  final int id;
  final String name;
  final String unit;
  final String price;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const TopProductModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}
