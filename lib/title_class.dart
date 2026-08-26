import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/utils/app_color.dart';
import 'package:grocery_admin_panel/utils/app_icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TitleClass extends StatefulWidget {
  final String title;

  final bool isEdit;
  final bool isStatus;
  final VoidCallback? onEditTap;
  final ValueChanged<String>? onStatusChanged;

  const TitleClass({
    super.key,
    required this.title,
    this.isEdit = false,

    this.isStatus = false,
    this.onEditTap,
    this.onStatusChanged,
  });

  @override
  State<TitleClass> createState() => _TitleClassState();
}

class _TitleClassState extends State<TitleClass> {
  static const List<String> statusList = [
    "Pending",
    "Processing",
    "Out of Delivery",
    "Delivered",
  ];
  String selectedStatus = "Pending";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Dashboard Title
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),


        if (widget.isEdit) ...[
          ElevatedButton.icon(
            onPressed: widget.onEditTap,
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text("Edit"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.animationGreen,
              foregroundColor: AppColor.bg1,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],
        if (widget.isStatus) ...[
          Container(
            height: 35.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColor.bg1,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColor.lightGray, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColor.textGray,
                ),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                items: statusList.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedStatus = newValue;
                    });
                    widget.onStatusChanged?.call(newValue);
                  }
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],

        SizedBox(width: 24.w),
        // 3. Admin Greeting & Profile Icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Hello Admin",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 8.w),
            const Icon(
              AppIcon.adminProfile,
              size: 26,
              color: Colors.black87,
            ),
          ],
        ),
      ],
    );
  }
}
