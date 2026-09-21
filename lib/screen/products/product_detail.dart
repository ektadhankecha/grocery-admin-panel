import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_admin_panel/screen/products/product_provider.dart';
import 'package:grocery_admin_panel/model/product_model.dart';
import 'package:grocery_admin_panel/title_class.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel? product;
  final VoidCallback? onBack;
  final ValueChanged<ProductModel>? onSave;

  const ProductDetail({super.key, this.product, this.onBack, this.onSave});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool isEditing = false;

  final TextEditingController productIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // LIFECYCLE

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    if (product != null) {
      // Existing product: load data into controllers and state
      productIdController.text = product.productId;
      nameController.text = product.name;
      imageController.text = product.image;
      categoryController.text = product.category;
      priceController.text = product.price;
      quantityController.text = product.quantity;
      stockController.text = product.stock;
      descriptionController.text = product.description ?? '';
    } else {
      // Adding a new product: open in edit mode with defaults
      isEditing = true;
    }
  }

  @override
  void dispose() {
    productIdController.dispose();
    nameController.dispose();
    imageController.dispose();
    categoryController.dispose();
    priceController.dispose();
    quantityController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // GETTERS & HELPERS

  bool get isAddMode => widget.product == null;

  String get screenTitle {
    if (isAddMode) return "Add Product";
    return isEditing ? "Edit Product" : "Product Detail";
  }

  String get buttonText {
    if (isAddMode) return "Save Product";
    return isEditing ? "Update Product" : "Edit Product";
  }

  // FORM VALIDATION & ACTIONS

  bool validateFields() {
    if (productIdController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty ||
        imageController.text.trim().isEmpty ||
        categoryController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        quantityController.text.trim().isEmpty ||
        stockController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      showSnackBar("Please fill in all fields", isError: true);
      return false;
    }
    return true;
  }

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColor.dltRed : AppColor.animationGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // MAIN BUILD METHOD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg3,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Screen Header (Title + Close Button)
          Row(
            children: [
              Expanded(child: TitleClass(title: screenTitle)),
              if (widget.onBack != null)
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.close, color: Colors.black87),
                  tooltip: "Close",
                ),
            ],
          ),
          SizedBox(height: 24.h),

          // 2. Main Content Card (Three Columns: Info Form | Image | Color Palette)
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColor.bg1,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: buildProductInfoSection()),
                  SizedBox(height: 20.h),

                  // Bottom Centered Action Button (Save / Edit / Update)
                  Center(
                    child: ElevatedButton(
                      // onPressed: handleButtonAction,
                      onPressed: () async {
                        if (!isAddMode && !isEditing) {
                          setState(() {
                            isEditing = true;
                          });
                          return;
                        }
                        if (!validateFields()) return;
                        if (isAddMode) {
                          final newProduct = ProductModel(
                            id: '', // Firestore will auto-generate the document ID
                            productId: productIdController.text.trim(),
                            name: nameController.text.trim(),
                            category: categoryController.text.trim(),
                            image: imageController.text.trim(),
                            stock: stockController.text.trim(),
                            price: priceController.text.trim(),
                            quantity: quantityController.text.trim(),
                            description: descriptionController.text.trim(),
                          );
                          await context.read<ProductProvider>().addProduct(
                            newProduct,
                          );
                          showSnackBar("Product added successfully!");
                          if (context.mounted) {
                            widget.onBack?.call();
                          }
                        } else {
                          final updatedProduct = ProductModel(
                            id: widget.product!.id, // Existing Firestore doc ID
                            productId: productIdController.text.trim(),
                            name: nameController.text.trim(),
                            category: categoryController.text.trim(),
                            image: imageController.text.trim(),
                            stock: stockController.text.trim(),
                            price: priceController.text.trim(),
                            quantity: quantityController.text.trim(),
                            description: descriptionController.text.trim(),
                          );
                          await context.read<ProductProvider>().updateProduct(
                            updatedProduct,
                          );
                          showSnackBar("Product updated successfully!");
                          if (context.mounted) {
                            setState(() => isEditing = false);
                            widget.onBack?.call();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.animationGreen,
                        foregroundColor: AppColor.bg1,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 48.w,
                          vertical: 14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  /// Left Column: Product details table form.
  Widget buildProductInfoSection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Information",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          Table(
            border: TableBorder.all(color: AppColor.dividerLine, width: 1),
            columnWidths: const {
              0: FlexColumnWidth(1), // Field Label (Ratio 1)
              1: FlexColumnWidth(2), // Input Field (Ratio 2)
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              buildTableRow(
                title: "Product ID",
                controller: productIdController,
                hintText: "e.g. #PRD-101",
                readOnly: !isEditing,
              ),
              buildTableRow(
                title: "Product Name",
                controller: nameController,
                hintText: "Enter product name",
                readOnly: !isEditing,
              ),
              buildTableRow(
                title: "Image URL",
                controller: imageController,
                hintText: "Enter image url",
                readOnly: !isEditing,
              ),
              buildTableRow(
                title: "Category",
                controller: categoryController,
                hintText: "e.g. Vegetables or Fruits",
                readOnly: !isEditing,
              ),
              buildTableRow(
                title: "Price",
                controller: priceController,
                hintText: "e.g. \$4.99",
                readOnly: !isEditing,
              ),
              buildTableRow(
                title: "Quantity",
                controller: quantityController,
                hintText: "e.g. 1 kg / 1 dozen",
                readOnly: !isEditing,
              ),
              buildTableRow(
                title: "Stock",
                controller: stockController,
                hintText: "e.g. 150 In Stock",
                readOnly: !isEditing,
              ),
              buildTableRow(
                title: "Description",
                controller: descriptionController,
                hintText: "Enter product description",
                maxLines: 3,
                readOnly: !isEditing,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Single table row for product form fields.
  TableRow buildTableRow({
    required String title,
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return TableRow(
      children: [
        // Label Column
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.textGray,
            ),
          ),
        ),
        // TextField Column
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: readOnly ? AppColor.textGray : Colors.black87,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColor.textGray,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
      ],
    );
  }
}
