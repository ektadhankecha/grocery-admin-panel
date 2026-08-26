import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/model/category_model.dart';
import 'package:grocery_admin_panel/screen/categories/category_data.dart';
import 'package:grocery_admin_panel/screen/products/product_data.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> categories = List.from(defaultCategoryList);

  void addCategory(CategoryModel category) {
    categories.add(category);
    notifyListeners();
  }

  void updateCategory(CategoryModel category) {
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      categories[index] = category;
      notifyListeners();
    }
  }

  void deleteCategory(int? id) {
    if (id == null) return;
    categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  int getProductCount(String categoryName) {
    final catName = categoryName.trim().toLowerCase();
    return productList.where((p) {
      final pCat = p.category.trim().toLowerCase();
      return pCat == catName ||
          pCat.contains(catName) ||
          catName.contains(pCat);
    }).length;
  }

  (Color bgColor, Color textColor) getCategoryColors(String categoryName) {
    final catName = categoryName.trim().toLowerCase();
    final found = categories.where((c) {
      final cName = c.name.trim().toLowerCase();
      return cName == catName ||
          cName.contains(catName) ||
          catName.contains(cName);
    }).firstOrNull;

    if (found != null) {
      return (found.bgColor, found.foregroundColor);
    }
    final defaultBg = AppColor.animationGreen.withValues(alpha: 0.12);
    return (defaultBg, AppColor.animationGreen);
  }
}
