class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    double parsePrice(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString().replaceAll('\$', '').trim()) ?? 0.0;
    }

    int parseQuantity(dynamic val) {
      if (val == null) return 1;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString().trim()) ?? 1;
    }

    return OrderItem(
      productId: map['productId']?.toString() ?? map['id']?.toString() ?? '',
      productName: map['productName']?.toString() ?? map['name']?.toString() ?? map['title']?.toString() ?? '',
      quantity: parseQuantity(map['quantity'] ?? map['qty'] ?? map['count']),
      price: parsePrice(map['price'] ?? map['totalPrice'] ?? map['productPrice']),
    );
  }
}

class OrderModel {
  final String docId;
  final String orderNumber;
  final String orderDate;
  final String paymentMethod;
  final String productId;
  final String productName;
  final int quantity;
  final double totalPrice;
  final String name;
  final String email;
  final String contact;
  final String address;
  final String city;
  final String country;
  final String zipCode;
  final String status;
  final List<OrderItem> items;

  OrderModel({
     this.docId = '',
    required this.orderNumber,
    required this.orderDate,
    required this.paymentMethod,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.name,
    required this.email,
    required this.contact,
    required this.address,
    required this.country,
    required this.city,
    required this.zipCode,
    required this.status,
    this.items = const [],
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    double parsePrice(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString().replaceAll('\$', '').trim()) ?? 0.0;
    }

    // Safe int parsing
    int parseQuantity(dynamic val) {
      if (val == null) return 1;
      if (val is int) return val;
      return int.tryParse(val.toString().trim()) ?? 1;
    }

    final userData = map['user'] is Map<String, dynamic>
        ? (map['user'] as Map<String, dynamic>)
        : (map['user'] is Map ? Map<String, dynamic>.from(map['user']) : <String, dynamic>{});


    // Check if 'address' is a Map in Firebase
    final addressData = map['address'] is Map<String, dynamic>
        ? (map['address'] as Map<String, dynamic>)
        : (map['address'] is Map ? Map<String, dynamic>.from(map['address']) : <String, dynamic>{} );

    // Read fields safely from userData, top-level map, or addressData
    final customerName = userData['name'] ?? map['name'] ?? addressData['name'] ?? '';
    final customerEmail = userData['email'] ?? map['email'] ?? addressData['email'] ?? '';
    final customerPhone = userData['contact'] ?? userData['phone'] ?? map['contact'] ?? addressData['phone'] ?? addressData['contact'] ?? '';
    final streetAddress = addressData['address'] ?? (map['address'] is String ? map['address'] : '');
    final city = addressData['city'] ?? map['city'] ?? '';
    final country = addressData['country'] ?? map['country'] ?? '';
    final zipCode = addressData['zipCode']?.toString() ?? map['zipCode']?.toString() ?? '';

    // Parse items list
    final rawItems = map['items'] ?? map['products'] ?? map['cart'] ?? map['orderItems'];
    List<OrderItem> itemList = [];
    if (rawItems is List && rawItems.isNotEmpty) {
      itemList = rawItems.map((item) {
        if (item is Map<String, dynamic>) {
          return OrderItem.fromMap(item);
        } else if (item is Map) {
          return OrderItem.fromMap(Map<String, dynamic>.from(item));
        }
        return OrderItem(productId: '', productName: item.toString(), quantity: 1, price: 0.0);
      }).toList();
    } else {
      final pName = map['productName']?.toString() ?? '';
      final pId = map['productId']?.toString() ?? '';
      if (pName.isNotEmpty || pId.isNotEmpty) {
        itemList.add(OrderItem(
          productId: pId,
          productName: pName,
          quantity: parseQuantity(map['quantity']),
          price: parsePrice(map['totalPrice']),
        ));
      }
    }

    final derivedProductName = itemList.isNotEmpty
        ? itemList.map((e) => e.productName).where((n) => n.isNotEmpty).join(', ')
        : (map['productName']?.toString() ?? '');
    final derivedProductId = itemList.isNotEmpty
        ? itemList.first.productId
        : (map['productId']?.toString() ?? '');
    final derivedQuantity = itemList.isNotEmpty
        ? itemList.fold<int>(0, (sum, item) => sum + item.quantity)
        : parseQuantity(map['quantity']);

    return OrderModel(
      docId: docId,
        orderNumber: map['orderNumber']?.toString() ?? '',
        orderDate: map['orderDate']?.toString() ?? '',
        paymentMethod: map['paymentMethod']?.toString() ?? '',
        productId: derivedProductId,
        productName: derivedProductName,
        quantity: derivedQuantity,
        totalPrice: parsePrice(map['totalPrice']),
        name: customerName.toString(),
        email: customerEmail.toString(),
        contact: customerPhone.toString(),
        address: streetAddress.toString(),
        country: country.toString(),
        city: city.toString(),
        zipCode: zipCode.toString(),
        status: map["status"]?.toString() ?? '',
        items: itemList);
  }
}