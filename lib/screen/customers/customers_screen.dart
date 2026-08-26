import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_admin_panel/model/customer_model.dart';
import 'package:grocery_admin_panel/screen/customers/customer_data.dart';
import 'package:grocery_admin_panel/title_class.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';
import 'package:grocery_admin_panel/utils/app_icon.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Filter customers list by search
  List<CustomerModel> get filteredCustomers {
    if (searchQuery.isEmpty) return customerList;
    final q = searchQuery.toLowerCase();
    return customerList.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.phone.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final customers = filteredCustomers;

    return Scaffold(
      backgroundColor: AppColor.bg3,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleClass(title: "Customers"),
          SizedBox(height: 24.h),

          // Main customer container
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: AppColor.bg1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top search row
                  Row(
                    children: [
                      const Spacer(),

                      // Search bar
                      Container(
                        width: 260.w,
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
                                  hintText: "Search customers...",
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
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Customer data table or empty state
                  Expanded(
                    child: customers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline_rounded,
                                  size: 60.r,
                                  color: AppColor.lightGray,
                                ),
                                SizedBox(height: 14.h),
                                const Text(
                                  "No Customers Found",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  searchQuery.isNotEmpty
                                      ? "No customers matching \"$searchQuery\"."
                                      : "No customer records available.",
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    color: AppColor.textGray,
                                  ),
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
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                dataTextStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13.5,
                                ),
                                horizontalMargin: 20,
                                columnSpacing: 28,
                                columns: const [
                                  DataColumn(label: Text('Photo')),
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('onBoarded date')),
                                  DataColumn(label: Text('Email')),
                                  DataColumn(label: Text('Phone number')),
                                  DataColumn(label: Text('Action')),
                                ],
                                rows: customers.map((customer) {
                                  return DataRow(
                                    cells: [
                                      // Photo cell
                                      DataCell(
                                        CircleAvatar(
                                          radius: 18,
                                          foregroundImage: AssetImage(
                                            customer.image,
                                          ),

                                          // child: ClipOval(child: Image.asset(customer.image,)),
                                        ),
                                      ),

                                      // Name cell
                                      DataCell(
                                        Text(
                                          customer.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),

                                      // Onboard date cell
                                      DataCell(
                                        Text(
                                          customer.onboardDate,
                                          style: const TextStyle(
                                            color: AppColor.textGray,
                                          ),
                                        ),
                                      ),

                                      // Email cell
                                      DataCell(Text(customer.email)),

                                      // Phone number cell
                                      DataCell(Text(customer.phone)),

                                      // Action cell
                                      DataCell(
                                        IconButton(
                                          onPressed: () {
                                            // Handle customer details view
                                          },
                                          icon: const Icon(
                                            Icons.visibility_outlined,
                                            color: AppColor.animationGreen,
                                            size: 20,
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
