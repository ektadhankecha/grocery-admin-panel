class CustomerModel {
  final String id;
  final String name;
  final String? image;
  final String onboardDate;
  final String email;
  final String phone;

  const CustomerModel({
    required this.id,
    required this.name,
    this.image,
    required this.onboardDate,
    required this.email,
    required this.phone,
  });
  factory CustomerModel.fromFireStore(Map<String, dynamic> data, String id) {
    final rawImage = (data['profileImage'] ?? data['image'])?.toString().trim();
    final imageStr = rawImage?.toString().trim();
    return CustomerModel(
      id: id,
      name: (data['name'] ?? '').toString(),
      image: (imageStr != null && imageStr.isNotEmpty) ? imageStr : null,
      onboardDate: (data['onboardDate'] ?? data['createdAt'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      phone: (data['phone'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'image': image,
      'onboardDate': onboardDate,
      'email': email,
      'phone': phone,
    };
  }
}
