import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:grocery_admin_panel/model/category_model.dart';
import 'package:grocery_admin_panel/screen/categories/category_provider.dart';
import 'package:grocery_admin_panel/title_class.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';
import 'package:grocery_admin_panel/utils/app_icon.dart';

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

// Color palette shades for category background
const List<String> categoryColors = [
  // Red
  '#FFF1F0', '#FFE4E1', '#FFCCC7', '#FFA39E', '#FF7875',
  '#FF4D4F', '#F5222D', '#CF1322', '#A8071A', '#820014',
  // Green
  '#F6FFED', '#E6F2EA', '#D9F7BE', '#B7EB8F', '#95DE64',
  '#52C41A', '#389E0D', '#237804', '#135200', '#092B00',
  // Pink
  '#FFF0F6', '#FEE1ED', '#FFD6E7', '#FFADD2', '#FF85C0',
  '#F759AB', '#EB2F96', '#C41D7F', '#9E1068', '#780650',
  // Yellow
  '#FEFFE6', '#FFFBE6', '#FFF1B8', '#FFE58F', '#FFD666',
  '#FFC53D', '#FAAD14', '#D48806', '#AD6800', '#874D00',
  // Orange
  '#FFF7E6', '#FFE7BA', '#FFD591', '#FFC069', '#FFA940',
  '#FA8C16', '#D46B08', '#AD4E00', '#873800', '#612500',
  // Blue
  '#E6F7FF', '#BAE7FF', '#91D5FF', '#69C0FF', '#40A9FF',
  '#1890FF', '#096DD9', '#0050B3', '#003A8C', '#002766',
  // Purple
  '#F9F0FF', '#EFDBFF', '#D3ADF7', '#B37FEB', '#9254DE',
  '#722ED1', '#531DAB', '#391085', '#22075E', '#120338',
  // Teal
  '#E6FFFB', '#B5F5EC', '#87E8DE', '#5CDBD3', '#36CFC9',
  '#13C2C2', '#08979C', '#006D75', '#00474F', '#002329',
  // Brown
  '#FDF8F5', '#F7EBE1', '#EDD5C1', '#DFBB9E', '#CFA07C',
  '#B88258', '#9C643B', '#7E4924', '#5E3113', '#3E1C07',
  // Gray
  '#FAFAFA', '#F5F5F5', '#E8E8E8', '#D9D9D9', '#BFBFBF',
  '#8C8C8C', '#595959', '#434343', '#262626', '#141414',
];

// Calculate contrast text/icon color for background
Color calculateFgColor(Color bgColor) {
  final luminance = bgColor.computeLuminance();
  if (luminance < 0.25) return Colors.white;
  final hsl = HSLColor.fromColor(bgColor);
  final darkened = hsl
      .withLightness((hsl.lightness - 0.40).clamp(0.18, 0.42))
      .withSaturation((hsl.saturation + 0.30).clamp(0.5, 1.0));
  return darkened.toColor();
}

// Category image widget helper (supports svg, asset and picked bytes)
Widget buildCategoryImage({
  required String imagePath,
  Uint8List? imageBytes,
  double? width,
  double? height,
  Color? fallbackColor,
}) {
  if (imageBytes != null) {
    return Image.memory(
      imageBytes,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }

  if (imagePath.isNotEmpty) {
    if (imagePath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => Icon(
          Icons.category_outlined,
          size: width != null ? (width * 0.6) : 28,
          color: fallbackColor ?? Colors.black54,
        ),
      );
    } else {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.category_outlined,
          size: width != null ? (width * 0.6) : 28,
          color: fallbackColor ?? Colors.black54,
        ),
      );
    }
  }

  return Icon(
    Icons.category_outlined,
    size: width != null ? (width * 0.6) : 28,
    color: fallbackColor ?? Colors.black54,
  );
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ImagePicker picker = ImagePicker();
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
    Uint8List? dialogImageBytes = isEdit ? category.imageBytes : null;
    String existingImagePath = isEdit ? category.image : '';
    Color selectedBgColor = isEdit ? category.bgColor : const Color(0xffE6F2EA);
    bool isNameEmpty = false;

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
                        const Text(
                          "Category Image",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textGray,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        InkWell(
                          onTap: () async {
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              maxWidth: 400,
                              maxHeight: 400,
                            );
                            if (image != null) {
                              final bytes = await image.readAsBytes();
                              setDialogState(() {
                                dialogImageBytes = bytes;
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            width: double.infinity,
                            height: 160.h,
                            decoration: BoxDecoration(
                              color: selectedBgColor,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColor.dividerLine,
                                width: 1.5,
                              ),
                            ),
                            child:
                                (dialogImageBytes != null ||
                                    existingImagePath.isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(12.r),
                                          child: buildCategoryImage(
                                            imagePath: existingImagePath,
                                            imageBytes: dialogImageBytes,
                                            width: 80.r,
                                            height: 80.r,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 8.h,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(
                                                alpha: 0.6,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                            child: Text(
                                              "Click to change image",
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 36.r,
                                        color: AppColor.textGray,
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        "Click to upload image from gallery",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.textGray,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
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
                              children: categoryColors.map((hex) {
                                final color = colorFromHex(hex);
                                final bool isSelected =
                                    selectedBgColor.toARGB32() ==
                                    color.toARGB32();
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
                              onPressed: () {
                                if (nameController.text.trim().isEmpty) {
                                  setDialogState(() {
                                    isNameEmpty = true;
                                  });
                                  return;
                                }

                                final Color chosenBg = selectedBgColor;
                                final Color chosenFg = calculateFgColor(
                                  chosenBg,
                                );

                                if (isEdit) {
                                  final updatedCat = CategoryModel(
                                    id: category.id,
                                    name: nameController.text.trim(),
                                    image: dialogImageBytes != null
                                        ? ''
                                        : category.image,
                                    imageBytes:
                                        dialogImageBytes ?? category.imageBytes,
                                    bgColor: chosenBg,
                                    foregroundColor: chosenFg,
                                  );
                                  context
                                      .read<CategoryProvider>()
                                      .updateCategory(updatedCat);
                                } else {
                                  final categories = context
                                      .read<CategoryProvider>()
                                      .categories;
                                  final newId = categories.isEmpty
                                      ? 1
                                      : ((categories
                                                .map((e) => e.id ?? 0)
                                                .reduce(
                                                  (a, b) => a > b ? a : b,
                                                )) +
                                            1);
                                  final newCat = CategoryModel(
                                    id: newId,
                                    name: nameController.text.trim(),
                                    imageBytes: dialogImageBytes,
                                    bgColor: chosenBg,
                                    foregroundColor: chosenFg,
                                  );
                                  context.read<CategoryProvider>().addCategory(
                                    newCat,
                                  );
                                }

                                Navigator.pop(ctx);
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
                              final productCount = categoryProvider
                                  .getProductCount(category.name);

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
                                      radius: 30.r,
                                      backgroundColor: category.bgColor,
                                      child: ClipOval(
                                        child: Padding(
                                          padding: EdgeInsets.all(7.r),
                                          child: buildCategoryImage(
                                            imagePath: category.image,
                                            imageBytes: category.imageBytes,
                                            width: 36.r,
                                            height: 36.r,
                                            fallbackColor:
                                                category.foregroundColor,
                                          ),
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

                                    // Product count
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
                                                .deleteCategory(category.id);
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
