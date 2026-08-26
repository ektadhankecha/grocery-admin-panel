import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:grocery_admin_panel/home_screen/home_provider.dart';
import 'package:grocery_admin_panel/home_screen/page_data.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: const BoxDecoration(
        color: AppColor.bg1,
       borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/app_icon.png',
                height: 50.h, // ScreenUtil: .h adapts height based on screen height
                width: 50.w,  // ScreenUtil: .w adapts width based on screen width
              ),
              SizedBox(width: 12.w), // ScreenUtil: .w adapts horizontal spacing
              Text(
                'Grocery App',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.animationGreen,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Divider(
              thickness: 3,
              color: AppColor.animationGreen,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: pageDataList.length,
              itemBuilder: (context, index) {
                final bool isSelected = homeProvider.currentIndex == index;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.animationGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: ListTile(
                    leading: Icon(
                      pageDataList[index].icon,
                      color: isSelected
                          ? AppColor.bg1
                          : AppColor.animationGreen,
                    ),
                    title: Text(
                      pageDataList[index].name,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected
                            ? AppColor.bg1
                            : AppColor.animationGreen,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      context.read<HomeProvider>().setIndex(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



