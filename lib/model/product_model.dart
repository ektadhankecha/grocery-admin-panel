class ProductModel {
  final String id;
  final String productId;
  final String name;
  final String category;
  final String image;
  final String stock;
  final String price;
  final String quantity;
  final String? description;

  const ProductModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.category,
    required this.image,
    required this.stock,
    required this.price,
    required this.quantity,
    required this.description,
  });
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      productId: data['productId'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      stock: data["stock"] ?? '',
      price: data['price'] ?? '',
      quantity: data['quantity'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId' : productId,
      'name': name,
      'category': category,
      'image': image,
      'stock': stock,
      'price': price,
      'quantity': quantity,
      'description': description,
    };
  }
}
