import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_admin_panel/title_class.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';

class OrderDetail extends StatelessWidget {
  final VoidCallback? onBack;
  final Map<String, dynamic>? orderData;

  const OrderDetail({super.key, this.onBack, this.orderData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg3,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: TitleClass(title: "Order Detail", isStatus: true),
              ),
              if (onBack != null)
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.close, color: Colors.black87),
                ),
            ],
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Basic Details Container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: AppColor.bg1,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Basic Details",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColor.lightGray,
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Column 1: Order ID
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Order ID",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textGray,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  orderData?['id'] != null
                                      ? orderData!['id'].toString()
                                      : "--",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // Column 2: Payment Method
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(

                                  "Order Date",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textGray,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                 Text(
                                  orderData?['date']?.toString() ?? "--",

                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // Column 3: Order Date
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Payment Method",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textGray,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "Cash on delivery",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // Column 4: Delivery Date
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Delivery Date",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textGray,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                const Text(
                                  "--",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // Column 5: Shipping Partner
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Shipping Partner",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textGray,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                const Text(
                                  "--",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  // 2. Product Information Container
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Product Information Container
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.56,
                            padding: EdgeInsets.all(24.r),
                            decoration: BoxDecoration(
                              color: AppColor.bg1,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Product Information",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColor.lightGray,
                                ),
                                SizedBox(height: 20.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      AppColor.bg3,
                                    ),
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'Product ID',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Product',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Quantity',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Total Amount',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                    rows: orderData != null
                                        ? [
                                            DataRow(
                                              cells: [
                                                DataCell(
                                                  Text(
                                                    orderData!['id']?.toString() ?? '--',
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    orderData!['name']?.toString() ?? '--',
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    orderData!['quantity']?.toString() ?? '1',
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    orderData!['price']?.toString() ?? '--',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        : const [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // Payment Summary Container
                          Container(
                            width: MediaQuery.of(context).size.width * 0.56,
                            padding: EdgeInsets.all(24.r),
                            decoration: BoxDecoration(
                              color: AppColor.bg1,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Payment Status Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Payment Status",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFEAEA),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: const Text(
                                        "Not Paid",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                // 2. Divider
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColor.lightGray,
                                ),
                                SizedBox(height: 16.h),
                                // 3. Subtotal Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Subtotal",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.textGray,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      orderData?['price']?.toString() ??
                                          "\$0.00",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                // 4. Shipping Charge Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Shipping Charge",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.textGray,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "\$0.00",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                // 5. Divider
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColor.lightGray,
                                ),
                                SizedBox(height: 16.h),
                                // 6. Total Payment Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total Payment",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      orderData?['price']?.toString() ??
                                          "\$0.00",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.animationGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 24.w),
                      // 3. Customer Information Container
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        padding: EdgeInsets.all(24.r),
                        decoration: BoxDecoration(
                          color: AppColor.bg1,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Customer Information",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColor.lightGray,
                            ),
                            SizedBox(height: 12.h),
                            // Name ListTile
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(
                                backgroundColor: AppColor.bg3,
                                child: Icon(
                                  Icons.person_outline,
                                  color: AppColor.textGray,
                                ),
                              ),
                              title: const Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.textGray,
                                ),
                              ),
                              subtitle: Text(
                                orderData?['customer']?.toString() ?? "--",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Email Address ListTile
                            const ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppColor.bg3,
                                child: Icon(
                                  Icons.email_outlined,
                                  color: AppColor.textGray,
                                ),
                              ),
                              title: Text(
                                "Email Address",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.textGray,
                                ),
                              ),
                              subtitle: Text(
                                "ekta@gmail.com",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Contact ListTile
                            const ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppColor.bg3,
                                child: Icon(
                                  Icons.phone_outlined,
                                  color: AppColor.textGray,
                                ),
                              ),
                              title: Text(
                                "Contact",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.textGray,
                                ),
                              ),
                              subtitle: Text(
                                "+1 (555) 382-9471",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Shipping Address ListTile
                            const ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppColor.bg3,
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: AppColor.textGray,
                                ),
                              ),
                              title: Text(
                                "Shipping Address",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.textGray,
                                ),
                              ),
                              subtitle: Text(
                                "123 Market St, New York, NY",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Payment ListTile
                            const ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppColor.bg3,
                                child: Icon(
                                  Icons.credit_card_outlined,
                                  color: AppColor.textGray,
                                ),
                              ),
                              title: Text(
                                "Payment",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.textGray,
                                ),
                              ),
                              subtitle: Text(
                                "Cash on delivery",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
