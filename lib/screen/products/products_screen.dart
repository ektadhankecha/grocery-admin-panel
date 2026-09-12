import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_admin_panel/screen/products/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_admin_panel/model/product_model.dart';
import 'package:grocery_admin_panel/screen/categories/category_provider.dart';
import 'package:grocery_admin_panel/screen/products/product_data.dart';
import 'package:grocery_admin_panel/screen/products/product_detail.dart';
import 'package:grocery_admin_panel/title_class.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';
import 'package:grocery_admin_panel/utils/app_icon.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String selectedButton = "All Products";
  String searchQuery = "";
  bool showProductDetail = false;
  ProductModel? selectedProduct;
 // final product = ProductProvider().products;
  final TextEditingController searchController = TextEditingController();





  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showDeleteDialog(ProductModel product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.bg1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text(
          "Product Delete",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        content: const Text(
          "Deleting this product will remove it from your store and category. Any \n existing customer orders containing this product will not be affected.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColor.textGray, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: AppColor.textGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: (){
              ProductProvider().deleteProduct(product.id);
            },
            // onPressed: () {
            //   setState(() {
            //     ProductProvider().deleteProduct(product.id);
            //   //  localProductList.removeWhere((p) => p.id == product.id);
            //   });
            //   Navigator.pop(ctx);
            // },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.dltRed,
              foregroundColor: AppColor.bg1,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final productProvider = context.watch<ProductProvider>();

    final products = productProvider.products;
    final filteredProducts = products.where((p) {
      final bool matchesCategory;
      if (selectedButton == "All Products") {
        matchesCategory = true;
      } else {
        final pCat = p.category.trim().toLowerCase();
        final sCat = selectedButton.trim().toLowerCase();
        matchesCategory =
            pCat == sCat || pCat.contains(sCat) || sCat.contains(pCat);
      }
      final bool matchesSearch =
          searchQuery.isEmpty ||
              p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              p.productId.toLowerCase().contains(searchQuery.toLowerCase()) ||
              p.id.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();


    final buttonList = [
      "All Products",
      ...categoryProvider.categories.map((c) => c.name),
    ];

    if (showProductDetail) {
      return ProductDetail(
        product: selectedProduct,
        onBack: () {
          setState(() {
            showProductDetail = false;
          });
        },
        onSave: (savedProduct) {
          setState(() {
            final existingIndex = products.indexWhere(
              (p) => p.id == savedProduct.id,
            );
            if (existingIndex != -1) {
              products[existingIndex] = savedProduct;
            } else {
              products.insert(0, savedProduct);
            }
            showProductDetail = false;
          });
        },
      );
    }
    return Scaffold(
      backgroundColor: AppColor.bg3,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleClass(title: "Products"),
          SizedBox(height: 24.h),
          // 2. Main Product Section
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: AppColor.bg1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Bar & Search Bar & Add Button
                  Row(
                    children: [
                      // Category Filter Buttons (Horizontally Scrollable)
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: buttonList.map((name) {
                              final bool isSelected = selectedButton == name;
                              return Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedButton = name;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? AppColor.animationGreen
                                        : Colors.transparent,
                                    foregroundColor: isSelected
                                        ? AppColor.bg1
                                        : Colors.black87,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Search Bar
                      Container(
                        width: 240.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: AppColor.bg1,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: AppColor.lightGray.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onChanged: (val) {
                                  setState(() {
                                    searchQuery = val.trim();
                                  });
                                },
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Search products...",
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: AppColor.textGray,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    left: 14.w,
                                    bottom: 3.h,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              width: 38.w,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: AppColor.lightGray.withValues(
                                      alpha: 0.6,
                                    ),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: const Icon(
                                AppIcon.search,
                                color: AppColor.textGray,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Add Product Button
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedProduct = null;
                            showProductDetail = true;
                          });
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text("Add"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.animationGreen,
                          foregroundColor: AppColor.bg1,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // GridView of Products or Empty State
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64.r,
                                  color: AppColor.lightGray,
                                ),
                                SizedBox(height: 16.h),
                                const Text(
                                  "No Products Found",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  searchQuery.isNotEmpty
                                      ? "No products matching \"$searchQuery\"."
                                      : "No products in \"$selectedButton\" category.",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textGray,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            itemCount: filteredProducts.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 260.w,
                                  crossAxisSpacing: 18.w,
                                  mainAxisSpacing: 18.h,
                                  mainAxisExtent: 290.h,
                                ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              // final (categoryBgColor, categoryTextColor) =
                              //     categoryProvider.getCategoryColors(
                              //       product.category,
                              //     );

                              return Container(
                                padding: EdgeInsets.all(14.r),
                                decoration: BoxDecoration(
                                  color: AppColor.bg1,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: AppColor.dividerLine,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.02,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Top Row: Category Chip & ID
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                         //   color: categoryBgColor,
                                            borderRadius: BorderRadius.circular(
                                              6.r,
                                            ),
                                          ),
                                          child: Text(
                                            product.category,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                         //     color: categoryTextColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "#PRD-${product.productId}",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: AppColor.textGray,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Center Product Icon Avatar
                                    Center(
                                      child: CircleAvatar(
                                        radius:  35.r,
                                        backgroundColor: product.bgColor,
                                        child: Image.network(product.image,height: 40,width: 40,),
                                      ),
                                    ),
                                 //Product Name
                                    Center(
                                      child: Text(
                                        product.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    // Price & Quantity
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product.price,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.animationGreen,
                                          ),
                                        ),
                                        Text(
                                          " / ${product.quantity}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColor.textGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Stock Pill
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Stock:",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          product.stock,
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: AppColor.dividerLine,
                                    ),
                                    // Action Buttons: Detail & Delete
                                    Row(
                                      children: [
                                        // Detail Button
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedProduct = product;
                                                showProductDetail = true;
                                              });
                                            },
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  AppColor.animationGreen,
                                              side: const BorderSide(
                                                color: AppColor.animationGreen,
                                                width: 1,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            child: Text(
                                              "Detail",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        // Delete Button
                                        InkWell(

                                          onTap: () async {
                                            await context.read<ProductProvider>().deleteProduct(product.id);
                                            // if (context.mounted) {
                                            //   Navigator.pop(context);
                                            // }
                              },
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(7.r),
                                            decoration: BoxDecoration(
                                              color: AppColor.offClear,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: const Icon(
                                              Icons.delete_outline_rounded,
                                              color: AppColor.dltRed,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
