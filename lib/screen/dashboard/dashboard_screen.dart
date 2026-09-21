import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_admin_panel/screen/customers/customer_provider.dart';
import 'package:grocery_admin_panel/screen/products/product_provider.dart';
import 'package:grocery_admin_panel/title_class.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';
import 'package:grocery_admin_panel/utils/app_icon.dart';
import 'package:grocery_admin_panel/screen/orders/order_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const List<String> periodList = ['Weekly', 'Monthly', 'Annual'];
  String selectedPeriod = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final customerProvider = context.watch<CustomerProvider>();
    final top10Order = orderProvider.orderList.take(10).toList();
    final top10Product = productProvider.products.take(10).toList();
    final order = orderProvider.orderList.length;
    final product = productProvider.products.length;
    final customer = customerProvider.customers.length;
    return Scaffold(
      backgroundColor: AppColor.bg3,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleClass(title: "Dash Board"),
          SizedBox(height: 30.h),
          // Row with 4 Dashboard Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DashboardCard(
                title: "Total Revenue",
                icon: AppIcon.totalRevenue,
                data: "\$2500",
                description: "increased by 10%",
              ),
              DashboardCard(
                title: "Total Order",
                icon: AppIcon.orders,
                data: order.toString(),
                description: "decreased by 15%",
              ),
              DashboardCard(
                title: "Total Product",
                icon: AppIcon.products,
                data: product.toString(),
                description: "decreased by 4%",
              ),
              DashboardCard(
                title: "Total Customer",
                icon: AppIcon.customers,
                data: customer.toString(),
                description: "increased by 2%",
              ),
            ],
          ),
          SizedBox(height: 30.h),
          // Row with 2 Containers (Responsive with Flex)
          Expanded(
            child: Row(
              children: [
                // 1. Top Product Container (Flex: 3)
                Expanded(
                  flex: 3,
                  child: Container(
                    height: double.infinity,
                    padding: EdgeInsets.all(40.r),
                    decoration: BoxDecoration(
                      color: AppColor.bg1,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Top Product",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColor.bg3,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedPeriod,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                    color: AppColor.textGray,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  items: periodList.map((String period) {
                                    return DropdownMenuItem<String>(
                                      value: period,
                                      child: Text(period),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedPeriod = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: ListView.builder(
                            itemCount: top10Product.length,
                            itemBuilder: (context, index) {
                              final product = top10Product[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: AppColor.bg3,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  leading: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    product.quantity,
                                    style: const TextStyle(
                                      color: AppColor.textGray,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: Text(
                                    product.price,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 24.w),
                // 2. Recent Orders Container (Flex: 7)
                Expanded(
                  flex: 7,
                  child: Container(
                    height: double.infinity,
                    padding: EdgeInsets.all(40.r),
                    decoration: BoxDecoration(
                      color: AppColor.bg1,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recent Orders",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.menu, size: 18),
                              label: const Text("Filter"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.bg3,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: SingleChildScrollView(
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Product',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Price',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Customer',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: top10Order.map((order) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(order.orderNumber.toString()),
                                      ),
                                      DataCell(
                                        Text(order.productName.toString()),
                                      ),
                                      DataCell(
                                        Text(order.orderDate.toString()),
                                      ),
                                      DataCell(Text(order.status.toString())),
                                      DataCell(
                                        Text(order.totalPrice.toString()),
                                      ),
                                      DataCell(Text(order.name.toString())),
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
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String data;
  final String description;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.data,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.19,
      height: 220.h,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      //  padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        color: AppColor.bg1,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColor.vegetableGreen,
            child: Icon(icon, size: 80, color: AppColor.animationGreen),
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              SizedBox(height: 20),
              Text(
                data,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
