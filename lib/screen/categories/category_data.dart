import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/model/category_model.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';

final List<CategoryModel> defaultCategoryList = [
  const CategoryModel(
    id: 1,
    name: 'Vegetables',
    image: 'assets/images/vegetable.svg',
    bgColor: AppColor.vegetableGreen,
    foregroundColor: AppColor.textGreen,
  ),
  const CategoryModel(
    id: 2,
    name: 'Fruits',
    image: 'assets/images/fruits.svg',
    bgColor: AppColor.fruitRed,
    foregroundColor: AppColor.favoriteRed,
  ),
  const CategoryModel(
    id: 3,
    name: 'Dairy',
    image: 'assets/images/baby.svg',
    bgColor: AppColor.babyBlue,
    foregroundColor: AppColor.blue,
  ),
  const CategoryModel(
    id: 5,
    name: 'Beverages',
    image: 'assets/images/beverage.svg',
    bgColor: AppColor.beverageYellow,
    foregroundColor: AppColor.newText,
  ),
  const CategoryModel(
    id: 6,
    name: 'Household',
    image: 'assets/images/household.svg',
    bgColor: AppColor.housePink,
    foregroundColor: Color(0xffC41D7F),
  ),
  const CategoryModel(
    id: 8,
    name: 'Grocery',
    image: 'assets/images/grocery.svg',
    bgColor: AppColor.groPurple,
    foregroundColor: Color(0xff722ED1),
  ),
];
