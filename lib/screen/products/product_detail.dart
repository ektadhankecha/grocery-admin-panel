import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grocery_admin_panel/model/product_model.dart';
import 'package:grocery_admin_panel/title_class.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';

// 1. COLOR PALETTE CONSTANTS & HELPER

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

final List<String> colors = const [
  // Red (10 shades)
  '#FFF1F0', '#FFE4E1', '#FFCCC7', '#FFA39E', '#FF7875',
  '#FF4D4F', '#F5222D', '#CF1322', '#A8071A', '#820014',

  // Green (10 shades)
  '#F6FFED', '#E6F2EA', '#D9F7BE', '#B7EB8F', '#95DE64',
  '#52C41A', '#389E0D', '#237804', '#135200', '#092B00',

  // Pink (10 shades)
  '#FFF0F6', '#FEE1ED', '#FFD6E7', '#FFADD2', '#FF85C0',
  '#F759AB', '#EB2F96', '#C41D7F', '#9E1068', '#780650',

  // Yellow (10 shades)
  '#FEFFE6', '#FFFBE6', '#FFF1B8', '#FFE58F', '#FFD666',
  '#FFC53D', '#FAAD14', '#D48806', '#AD6800', '#874D00',

  // Orange (10 shades)
  '#FFF7E6', '#FFE7BA', '#FFD591', '#FFC069', '#FFA940',
  '#FA8C16', '#D46B08', '#AD4E00', '#873800', '#612500',

  // Blue (10 shades)
  '#E6F7FF', '#BAE7FF', '#91D5FF', '#69C0FF', '#40A9FF',
  '#1890FF', '#096DD9', '#0050B3', '#003A8C', '#002766',

  // Purple (10 shades)
  '#F9F0FF', '#EFDBFF', '#D3ADF7', '#B37FEB', '#9254DE',
  '#722ED1', '#531DAB', '#391085', '#22075E', '#120338',

  // Teal (10 shades)
  '#E6FFFB', '#B5F5EC', '#87E8DE', '#5CDBD3', '#36CFC9',
  '#13C2C2', '#08979C', '#006D75', '#00474F', '#002329',

  // Brown (10 shades)
  '#FDF8F5', '#F7EBE1', '#EDD5C1', '#DFBB9E', '#CFA07C',
  '#B88258', '#9C643B', '#7E4924', '#5E3113', '#3E1C07',

  // Gray (10 shades)
  '#FAFAFA', '#F5F5F5', '#E8E8E8', '#D9D9D9', '#BFBFBF',
  '#8C8C8C', '#595959', '#434343', '#262626', '#141414',
];

// 2. PRODUCT DETAIL WIDGET

class ProductDetail extends StatefulWidget {
  final ProductModel? product;
  final VoidCallback? onBack;
  final ValueChanged<ProductModel>? onSave;

  const ProductDetail({super.key, this.product, this.onBack, this.onSave});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // STATE VARIABLES & CONTROLLERS

  /// Controls whether form fields are editable or read-only (defaults to false).
  bool isEditing = false;

  /// Selected background hex code (defaults to Mint Green '#E6F2EA').
  String selectedColor = '#E6F2EA';

  /// In-memory image bytes if the user picks a new photo.
  Uint8List? pickedImageBytes;
  final ImagePicker picker = ImagePicker();

  // Form Text Controllers (Initialized directly at declaration)
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
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
      pickedImageBytes = product.imageBytes;
      selectedColor = colors.firstWhere(
        (hex) => colorFromHex(hex).toARGB32() == product.bgColor.toARGB32(),
        orElse: () => '#FFE4E1',
      );
      idController.text = "#PRD-${product.id}";
      nameController.text = product.name;
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
    idController.dispose();
    nameController.dispose();
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
    if (idController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty ||
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

  void handleButtonAction() {
    if (isAddMode) {
      saveNewProduct();
    } else if (!isEditing) {
      // Switch from view mode to edit mode
      setState(() => isEditing = true);
    } else {
      updateExistingProduct();
    }
  }

  void saveNewProduct() {
    if (!validateFields()) return;

    // Clean user-entered ID
    final cleanIdStr = idController.text
        .replaceAll('#', '')
        .replaceAll('PRD-', '')
        .replaceAll('prd-', '')
        .trim();

    final int? parsedId = int.tryParse(cleanIdStr);
    if (parsedId == null || parsedId <= 0) {
      showSnackBar(
        "Please enter a valid numeric Product ID (e.g. 101 or #PRD-101)",
        isError: true,
      );
      return;
    }

    final int newId = parsedId;

    final newProduct = ProductModel(
      id: newId,
      name: nameController.text.trim(),
      category: categoryController.text.trim(),
      imageBytes: pickedImageBytes,
      bgColor: colorFromHex(selectedColor),
      stock: stockController.text.trim(),
      price: formatPrice(priceController.text.trim()),
      quantity: quantityController.text.trim(),
      description: descriptionController.text.trim(),
    );

    showSnackBar("Product added successfully!");
    widget.onSave?.call(newProduct);
    widget.onBack?.call();
  }

  void updateExistingProduct() {
    if (!validateFields()) return;

    final updatedProduct = ProductModel(
      id: widget.product!.id,
      name: nameController.text.trim(),
      category: categoryController.text.trim(),
      image: pickedImageBytes == null ? widget.product!.image : null,
      imageBytes: pickedImageBytes ?? widget.product!.imageBytes,
      bgColor: colorFromHex(selectedColor),
      stock: stockController.text.trim(),
      price: formatPrice(priceController.text.trim()),
      quantity: quantityController.text.trim(),
      description: descriptionController.text.trim(),
    );

    showSnackBar("Product updated successfully!");
    widget.onSave?.call(updatedProduct);
    setState(() => isEditing = false);
    widget.onBack?.call();
  }

  String formatPrice(String price) {
    return price.startsWith('\$') ? price : '\$$price';
  }


  // IMAGE PICKER & DIALOGS

  Future<void> pickImage() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 80,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          pickedImageBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
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
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (50%): Product Information Table Form
                        Expanded(flex: 50, child: buildProductInfoSection()),
                        SizedBox(width: 24.w),

                        // Middle Column (25%): Product Image Card
                        Expanded(flex: 25, child: buildImageSection()),
                        SizedBox(width: 24.w),

                        // Right Column (25%): Background Color Picker Card
                        Expanded(
                          flex: 25,
                          child: buildColorSelectionSection(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Bottom Centered Action Button (Save / Edit / Update)
                  Center(child: buildActionButton()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // MODULAR UI COMPONENTS




  /// Left Column: Product details table form.
  Widget buildProductInfoSection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text("Product Information",
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
                controller: idController,
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

  /// Middle Column: Product image container.
  Widget buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
      "Product Image",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          height: 320.h,
          decoration: BoxDecoration(
            color: colorFromHex(selectedColor),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColor.dividerLine, width: 1.5),
          ),
          child: buildImageContent(),
        ),
      ],
    );
  }

  /// Internal widget rendering the product image (memory bytes or asset path), or upload placeholder.
  Widget buildImageContent() {
    // 1. Resolve image provider widget (picked bytes or asset path)
    Widget? imageWidget;
    if (pickedImageBytes != null) {
      imageWidget = Image.memory(pickedImageBytes!, fit: BoxFit.contain);
    } else if (widget.product?.image != null && widget.product!.image!.isNotEmpty) {
      imageWidget = Image.asset(
        widget.product!.image!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image_outlined, size: 48, color: Colors.black54),
        ),
      );
    }

    // 2. If an image is available, render inside full container with edit badge
    if (imageWidget != null) {
      return InkWell(
        onTap: isEditing ? pickImage : null,
        mouseCursor: isEditing ? SystemMouseCursors.click : SystemMouseCursors.basic,
        borderRadius: BorderRadius.circular(20.r),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: imageWidget,
              ),
              if (isEditing) ...[
                buildEditBadge(),
                Positioned(
                  bottom: 12.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "Click to change photo",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // 3. Fallback upload placeholder (no image yet)
    return InkWell(
      onTap: isEditing ? pickImage : null,
      mouseCursor: isEditing ? SystemMouseCursors.click : SystemMouseCursors.basic,
      borderRadius: BorderRadius.circular(20.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: AppColor.lightGray.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              size: 40.r,
              color: AppColor.textGray,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            "Upload product photo",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Click to browse files (PNG, JPG)",
            style: TextStyle(fontSize: 12.sp, color: AppColor.textGray),
          ),
        ],
      ),
    );
  }

  /// Small floating edit badge on the image card.
  Widget buildEditBadge() {
    return Positioned(
      top: 14.h,
      right: 14.w,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: const BoxDecoration(
          color: AppColor.animationGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.edit_outlined, color: AppColor.bg1, size: 16),
      ),
    );
  }

  /// Right Column: Clean continuous color palette of all shades (10 per family) and selected color info.
  Widget buildColorSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text("BackGround Color",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          height: 320.h,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColor.bg3,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColor.dividerLine, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // All Color Shades Swatches Grid
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: colors.map((hex) {
                      final color = colorFromHex(hex);
                      final bool isSelected =
                          selectedColor.toLowerCase() == hex.toLowerCase();
                      final bool isDark = color.computeLuminance() < 0.45;

                      return Tooltip(
                        message: hex,
                        child: InkWell(
                          onTap: isEditing
                              ? () {
                                  setState(() {
                                    selectedColor = hex;
                                  });
                                }
                              : null,
                          mouseCursor: isEditing
                              ? SystemMouseCursors.click
                              : SystemMouseCursors.basic,
                          borderRadius: BorderRadius.circular(16.r),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
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
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.6),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? Center(
                                    child: Icon(
                                      Icons.check,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                      size: 16.r,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // Selected Color Info Box
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColor.bg1,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColor.dividerLine),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: BoxDecoration(
                        color: colorFromHex(selectedColor),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.dividerLine),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selected Color",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColor.textGray,
                            ),
                          ),
                          Text(
                            selectedColor,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Primary button to Save / Edit / Update the product.
  Widget buildActionButton() {
    return ElevatedButton(
      onPressed: handleButtonAction,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.animationGreen,
        foregroundColor: AppColor.bg1,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
