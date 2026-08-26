import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/screen/orders/order_detail.dart';
import 'package:grocery_admin_panel/title_class.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';
import 'package:grocery_admin_panel/utils/app_icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_admin_panel/screen/dashboard/recent_order_data.dart';

class OrdersScreen extends StatefulWidget {

  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<String> buttonList = const [
    "All Orders",
    "Pending",
    "Processing",
    "Out of Delivery",
    "Delivered",
  ];

  String selectedButton = "All Orders";
  bool showOrderDetail = false;
  Map<String, dynamic>? selectedOrder;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredOrders {
    return recentOrderList.where((order) {
      // 1. Status Filter
      final bool matchesStatus = selectedButton == "All Orders" ||
          order['status']?.toString().toLowerCase() ==
              selectedButton.toLowerCase();

      // 2. Search Filter on Order ID
      final String idStr = order['id']?.toString() ?? '';
      final bool matchesSearch = searchQuery.isEmpty ||
          idStr.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (showOrderDetail) {
      return OrderDetail(
        orderData : selectedOrder,
        onBack: () {
          setState(() {
            showOrderDetail = false;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColor.bg3,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleClass(title: "Orders"),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              OrdersContainer(title: "Total Orders", count: "1000"),
              OrdersContainer(title: "Total Pending Orders", count: "100"),
              OrdersContainer(title: "Total Processing Orders", count: "200"),
              OrdersContainer(
                title: "Total On Delivery Orders",
                count: "150",
              ),
              OrdersContainer(title: "Total Complete Orders", count: "550"),
            ],
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 40.r, horizontal: 30.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: AppColor.bg1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Orders List",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ...buttonList.map((name) {
                        final bool isSelected = selectedButton == name;
                        return Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedButton = name;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? AppColor.animationGreen
                                  : Colors.transparent,
                              foregroundColor: isSelected
                                  ? AppColor.bg1
                                  : Colors.black,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(name),
                          ),
                        );
                      }),
                      const Spacer(),
                      Container(
                        width: 260.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          color: AppColor.bg1,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: AppColor.lightGray,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value.trim();
                                  });
                                },
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Search by Order ID...",
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textGray,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    left: 16.w,
                                    bottom: 3.h,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              width: 44.w,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: AppColor.lightGray,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: const Icon(
                                AppIcon.search,
                                color: AppColor.textGray,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: filteredOrders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64.r,
                                  color: AppColor.lightGray,
                                ),
                                SizedBox(height: 16.h),
                                const Text(
                                  "No Orders Found",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  searchQuery.isNotEmpty
                                      ? "No orders found matching Order ID \"$searchQuery\"."
                                      : (selectedButton == "All Orders"
                                          ? "There are currently no orders available."
                                          : "No orders found with status \"$selectedButton\"."),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textGray,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(
                                  AppColor.bg3,
                                ),
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'ID',
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
                                      'Date',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Status',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Price',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Customer',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Action',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: filteredOrders.map((order) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(order['id'].toString())),
                                      DataCell(Text(order['name'].toString())),
                                      DataCell(Text(order['date'].toString())),
                                      DataCell(Text(order['status'].toString())),
                                      DataCell(Text(order['price'].toString())),
                                      DataCell(Text(order['customer'].toString())),
                                      DataCell(
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedOrder = order;
                                              showOrderDetail = true;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.visibility_outlined,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
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
}

class OrdersContainer extends StatelessWidget {
  final String title;
  final String count;

  const OrdersContainer({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      width: MediaQuery.of(context).size.width * 0.14,
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: AppColor.bg1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColor.textGray,
            ),
          ),
          Text(
            count,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
