// Model representing a Customer
class CustomerModel {
  final int id;
  final String name;
  final String image;
  final String onboardDate;
  final String email;
  final String phone;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.image,
    required this.onboardDate,
    required this.email,
    required this.phone,
  });
}
