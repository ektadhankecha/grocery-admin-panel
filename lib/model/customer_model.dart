import 'package:cloud_firestore/cloud_firestore.dart';

// Model representing a Customer
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
    String parseDate(dynamic val) {
      if (val == null) return '';
      if (val is Timestamp) {
        final d = val.toDate();
        return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
      }
      if (val is DateTime) {
        return "${val.day.toString().padLeft(2, '0')}/${val.month.toString().padLeft(2, '0')}/${val.year}";
      }
      return val.toString();
    }

    final rawImage = data['image'] ??
        data['imageUrl'] ??
        data['image_url'] ??
        data['photoUrl'] ??
        data['photoURL'] ??
        data['photo_url'] ??
        data['profile'] ??
        data['profileImage'] ??
        data['profile_image'] ??
        data['profilePicture'] ??
        data['profile_picture'] ??
        data['profilePic'] ??
        data['profile_pic'] ??
        data['avatar'] ??
        data['avatarUrl'] ??
        data['avatar_url'] ??
        data['userImage'] ??
        data['user_image'] ??
        data['userProfile'] ??
        data['photo'] ??
        data['picture'] ??
        data['img'] ??
        data['pic'];
    final imageStr = rawImage?.toString().trim();

    return CustomerModel(
      id: id,
      name: (data['name'] ??
              data['fullName'] ??
              data['userName'] ??
              data['displayName'] ??
              '')
          .toString(),
      image: (imageStr != null && imageStr.isNotEmpty) ? imageStr : null,
      onboardDate: parseDate(data['onboardDate'] ??
          data['createdAt'] ??
          data['date'] ??
          data['joinedDate'] ??
          data['created_at'] ??
          data['timestamp']),
      email: (data['email'] ?? '').toString(),
      phone: (data['phone'] ??
              data['phoneNumber'] ??
              data['contact'] ??
              data['mobile'] ??
              '')
          .toString(),
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
