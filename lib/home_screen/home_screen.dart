import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';
import 'package:grocery_admin_panel/home_screen/custom_navigation_bar.dart';
import 'package:grocery_admin_panel/home_screen/home_provider.dart';
import 'package:grocery_admin_panel/screen/banners/banners_screen.dart';
import 'package:grocery_admin_panel/screen/categories/categories_screen.dart';
import 'package:grocery_admin_panel/screen/customers/customers_screen.dart';
import 'package:grocery_admin_panel/screen/dashboard/dashboard_screen.dart';
import 'package:grocery_admin_panel/screen/orders/orders_screen.dart';
import 'package:grocery_admin_panel/screen/products/products_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Widget> pages = const [
    DashboardScreen(),
    OrdersScreen(),
    ProductsScreen(),
    CategoriesScreen(),
    BannersScreen(),
    CustomersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final int currentIndex = context.watch<HomeProvider>().currentIndex;

    return Scaffold(
      backgroundColor: AppColor.bg3,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Row(
          children: [
            const CustomNavigationBar(),
            const SizedBox(width: 40),
            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
