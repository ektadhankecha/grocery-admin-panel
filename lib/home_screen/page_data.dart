import 'package:grocery_admin_panel/model/page_model.dart';
import 'package:grocery_admin_panel/utils/app_icon.dart';

final List<PageModel> pageDataList = [
  const PageModel(
    id: 1,
    name: 'Dashboard',
    icon: AppIcon.dashboard,
  ),
  const PageModel(
    id: 2,
    name: 'Orders',
    icon: AppIcon.orders,
  ),
  const PageModel(
    id: 3,
    name: 'Products',
    icon: AppIcon.products,
  ),
  const PageModel(
    id: 4,
    name: 'Categories',
    icon: AppIcon.categories,
  ),
  const PageModel(
    id: 5,
    name: 'Banners',
    icon: AppIcon.banners,
  ),
  const PageModel(
    id: 6,
    name: 'Customers',
    icon: AppIcon.customers,
  ),
];

