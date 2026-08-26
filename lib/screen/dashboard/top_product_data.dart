import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/model/top_product_model.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';

final List<TopProductModel> topProductList = [
  const TopProductModel(
    id: 1,
    name: 'Fresh Apple',
    unit: 'dozen',
    price: '\$4.99',
    icon: Icons.apple_rounded,
    iconColor: AppColor.favoriteRed,
    iconBgColor: AppColor.vegetableGreen,
  ),
  const TopProductModel(
    id: 2,
    name: 'Organic Broccoli',
    unit: '1 kg',
    price: '\$2.49',
    icon: Icons.eco_rounded,
    iconColor: AppColor.textGreen,
    iconBgColor: AppColor.broccoli,
  ),
  const TopProductModel(
    id: 3,
    name: 'Sweet Banana',
    unit: 'dozen',
    price: '\$1.99',
    icon: Icons.eco_outlined,
    iconColor: AppColor.newText,
    iconBgColor: AppColor.beverageYellow,
  ),
  const TopProductModel(
    id: 4,
    name: 'Fresh Avocado',
    unit: '2.0 lbs',
    price: '\$3.80',
    icon: Icons.spa_rounded,
    iconColor: AppColor.animationGreen,
    iconBgColor: AppColor.avocado,
  ),
  const TopProductModel(
    id: 5,
    name: 'Green Grapes',
    unit: '5.0 lbs',
    price: '\$5.20',
    icon: Icons.bubble_chart_rounded,
    iconColor: AppColor.textGreen,
    iconBgColor: AppColor.grapes,
  ),
  const TopProductModel(
    id: 6,
    name: 'Fresh Avocado',
    unit: '2.0 lbs',
    price: '\$3.80',
    icon: Icons.spa_rounded,
    iconColor: AppColor.animationGreen,
    iconBgColor: AppColor.avocado,
  ),
  const TopProductModel(
    id: 7,
    name: 'Fresh Avocado',
    unit: '2.0 lbs',
    price: '\$3.80',
    icon: Icons.spa_rounded,
    iconColor: AppColor.animationGreen,
    iconBgColor: AppColor.avocado,
  ),
];