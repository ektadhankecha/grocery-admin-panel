import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_admin_panel/screen/products/product_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:grocery_admin_panel/model/category_model.dart';
import 'package:grocery_admin_panel/screen/categories/category_provider.dart';
import 'package:grocery_admin_panel/title_class.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';
import 'package:grocery_admin_panel/utils/app_icon.dart';

// Color palette shades for category background (ARGB32)
const List<int> categoryColors = [
  // Red
  0xFFFFF1F0, 0xFFFFE4E1, 0xFFFFCCC7, 0xFFFFA39E, 0xFFFF7875,
  0xFFFF4D4F, 0xFFF5222D, 0xFFCF1322, 0xFFA8071A, 0xFF820014,
  // Green
  0xFFF6FFED, 0xFFE6F2EA, 0xFFD9F7BE, 0xFFB7EB8F, 0xFF95DE64,
  0xFF52C41A, 0xFF389E0D, 0xFF237804, 0xFF135200, 0xFF092B00,
  // Pink
  0xFFFFF0F6, 0xFFFEE1ED, 0xFFFFD6E7, 0xFFFFADD2, 0xFFFF85C0,
  0xFFF759AB, 0xFFEB2F96, 0xFFC41D7F, 0xFF9E1068, 0xFF780650,
  // Yellow
  0xFFFEFFE6, 0xFFFFFBE6, 0xFFFFF1B8, 0xFFFFE58F, 0xFFFFD666,
  0xFFFFC53D, 0xFFFAAD14, 0xFFD48806, 0xFFAD6800, 0xFF874D00,
  // Orange
  0xFFFFF7E6, 0xFFFFE7BA, 0xFFFFD591, 0xFFFFC069, 0xFFFFA940,
  0xFFFA8C16, 0xFFD46B08, 0xFFAD4E00, 0xFF873800, 0xFF612500,
  // Blue
  0xFFE6F7FF, 0xFFBAE7FF, 0xFF91D5FF, 0xFF69C0FF, 0xFF40A9FF,
  0xFF1890FF, 0xFF096DD9, 0xFF0050B3, 0xFF003A8C, 0xFF002766,
  // Purple
  0xFFF9F0FF, 0xFFEFDBFF, 0xFFD3ADF7, 0xFFB37FEB, 0xFF9254DE,
  0xFF722ED1, 0xFF531DAB, 0xFF391085, 0xFF22075E, 0xFF120338,
  // Teal
  0xFFE6FFFB, 0xFFB5F5EC, 0xFF87E8DE, 0xFF5CDBD3, 0xFF36CFC9,
  0xFF13C2C2, 0xFF08979C, 0xFF006D75, 0xFF00474F, 0xFF002329,
  // Brown
  0xFFFDF8F5, 0xFFF7EBE1, 0xFFEDD5C1, 0xFFDFBB9E, 0xFFCFA07C,
  0xFFB88258, 0xFF9C643B, 0xFF7E4924, 0xFF5E3113, 0xFF3E1C07,
  // Gray
  0xFFFAFAFA, 0xFFF5F5F5, 0xFFE8E8E8, 0xFFD9D9D9, 0xFFBFBFBF,
  0xFF8C8C8C, 0xFF595959, 0xFF434343, 0xFF262626, 0xFF141414,
];

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
 // final ImagePicker picker = ImagePicker();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Open Add / Edit category dialog
  void showAddEditCategoryDialog({CategoryModel? category}) {
    final bool isEdit = category != null;
    final TextEditingController nameController = TextEditingController(
      text: isEdit ? category.name : '',
    );
    final TextEditingController imageController = TextEditingController(
      text: isEdit ? category.image : '',
    );
    /// String existingImagePath = isEdit ? category.image : '';
    Color selectedBgColor = isEdit ? category.bgColor :  Color(categoryColors.first);
    bool isNameEmpty = false;
    bool isImageUrlEmpty = false;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: AppColor.bg1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 370, minWidth: 340),
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dialog header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isEdit ? "Edit Category" : "Add Category",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black87,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Name input
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60.w,
                              child: const Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.textGray,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: TextField(
                                controller: nameController,
                                onChanged: (val) {
                                  if (isNameEmpty && val.trim().isNotEmpty) {
                                    setDialogState(() {
                                      isNameEmpty = false;
                                    });
                                  }
                                },
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Enter category name",
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: AppColor.textGray,
                                  ),
                                  errorText: isNameEmpty
                                      ? "Category name cannot be empty"
                                      : null,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 10.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(
                                      color: AppColor.dividerLine,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(
                                      color: AppColor.dividerLine,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(
                                      color: AppColor.animationGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Image picker section
                        Row(
                          children: [
                            SizedBox(
                              width: 60.w,
                              child: const Text(
                                "Image",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.textGray,
                                ),
                              ),
                            ),

                            SizedBox(width: 12.w),
                            Expanded(
                              child: TextField(
                                controller: imageController,
                                onChanged: (val) {
                                  if (isImageUrlEmpty &&
                                      val.trim().isNotEmpty) {
                                    setDialogState(() {
                                      isImageUrlEmpty = false;
                                    });
                                  }
                                },
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Enter category name",
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: AppColor.textGray,
                                  ),
                                  errorText: isImageUrlEmpty
                                      ? "Image Url cannot be empty"
                                      : null,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 10.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(
                                      color: AppColor.dividerLine,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(
                                      color: AppColor.dividerLine,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(
                                      color: AppColor.animationGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Background color selector
                        const Text(
                          "Background Color",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textGray,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 160.h,
                          width: double.infinity,
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color: AppColor.bg3,
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(color: AppColor.dividerLine),
                          ),
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 6.w,
                              runSpacing: 6.h,
                              children: categoryColors.map((argb) {
                                final color = Color(argb);
                                final bool isSelected =
                                    selectedBgColor.toARGB32() == argb;
                                final bool isDark =
                                    color.computeLuminance() < 0.45;

                                return InkWell(
                                  onTap: () {
                                    setDialogState(() {
                                      selectedBgColor = color;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Container(
                                    width: 28.r,
                                    height: 28.r,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.black
                                            : AppColor.dividerLine,
                                        width: isSelected ? 2.5 : 1,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Icon(
                                              Icons.check,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              size: 13.r,
                                            ),
                                          )
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Dialog buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                            SizedBox(width: 12.w),
                            ElevatedButton(
                              onPressed: () async {
                                if (nameController.text.trim().isEmpty) {
                                  setDialogState(() {
                                    isNameEmpty = true;
                                  });
                                  return;
                                }
                                if (imageController.text.trim().isEmpty) {
                                  setDialogState(() {
                                    isImageUrlEmpty = true;
                                  });
                                  return;
                                }
                                if (isEdit) {
                                  await context
                                      .read<CategoryProvider>()
                                      .updateCategory(
                                        id: category.id,
                                        name: nameController.text.trim(),
                                        image: imageController.text.trim(),
                                        bgColor: selectedBgColor,
                                      );
                                }else {
                                  await context
                                      .read<CategoryProvider>()
                                      .addCategory(
                                    name: nameController.text.trim(),
                                    bgColor: selectedBgColor,
                                    image: imageController.text.trim(),
                                  );
                                }
                                if(context.mounted) {
                                  Navigator.pop(ctx);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.animationGreen,
                                foregroundColor: AppColor.bg1,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                isEdit ? "Update" : "Add",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final productProvider = context.watch<ProductProvider>();
    final categories = categoryProvider.categories;

    // Filter categories by search
    final filteredCategories = categories.where((c) {
      if (searchQuery.isEmpty) return true;
      final q = searchQuery.toLowerCase();
      return c.name.toLowerCase().contains(q) ||
          (c.id != null && c.id.toString().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: AppColor.bg3,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleClass(title: "Categories"),
          SizedBox(height: 24.h),

          // Categories container
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColor.bg1,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title row
                  Row(
                    children: [
                      const Spacer(),
                      // Search bar
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
                                  hintText: "Search categories...",
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
                            InkWell(
                              onTap: () {
                                if (searchQuery.isNotEmpty) {
                                  searchController.clear();
                                  setState(() {
                                    searchQuery = '';
                                  });
                                }
                              },
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(24.r),
                                bottomRight: Radius.circular(24.r),
                              ),
                              child: Container(
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
                                child: Icon(
                                  searchQuery.isNotEmpty
                                      ? Icons.close_rounded
                                      : AppIcon.search,
                                  color: AppColor.textGray,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),

                      // Add button
                      ElevatedButton.icon(
                        onPressed: () => showAddEditCategoryDialog(),
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
                  Expanded(
                    child: filteredCategories.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  size: 60.r,
                                  color: AppColor.lightGray,
                                ),
                                SizedBox(height: 14.h),
                                const Text(
                                  "No Categories Found",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  searchQuery.isNotEmpty
                                      ? "No category matching \"$searchQuery\"."
                                      : "No categories available.",
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    color: AppColor.textGray,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            itemCount: filteredCategories.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 160.w,
                                  crossAxisSpacing: 18.w,
                                  mainAxisSpacing: 18.h,
                                  mainAxisExtent: 240.h,
                                ),
                            itemBuilder: (context, index) {
                              final category = filteredCategories[index];
                              final productCount = categoryProvider.getProductCount(category.name,productProvider.products);

                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.r,
                                  vertical: 14.r,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.bg1,
                                  borderRadius: BorderRadius.circular(18.r),
                                  border: Border.all(
                                    color: AppColor.dividerLine,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.02,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Avatar
                                    CircleAvatar(
                                      radius: 40.r,
                                      backgroundColor: category.bgColor,
                                      child: ClipOval(
                                        child: Image.network(
                                          category.image,
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),

                                    // Name
                                    Text(
                                      category.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13.5.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),

                                  //  Product count
                                    Text(
                                      "$productCount ${productCount == 1 ? 'Product' : 'Products'}",
                                      style: TextStyle(
                                        fontSize: 11.5.sp,
                                        color: AppColor.textGray,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    // Edit and delete buttons
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 34.h,
                                            child: OutlinedButton(
                                              onPressed: () =>
                                                  showAddEditCategoryDialog(
                                                    category: category,
                                                  ),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    AppColor.animationGreen,
                                                side: const BorderSide(
                                                  color:
                                                      AppColor.animationGreen,
                                                  width: 1.2,
                                                ),
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.r,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                "Edit",
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        InkWell(
                                          onTap: () {
                                            context
                                                .read<CategoryProvider>()
                                                .deleteCategory(category.id,category.name);
                                          },
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          child: Container(
                                            height: 34.h,
                                            width: 34.w,
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
