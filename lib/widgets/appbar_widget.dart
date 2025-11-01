import 'package:flutter/material.dart';
import 'package:health_link_plus/utils/app_colors.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? elevation;
  final Widget? leading;
  final List<Widget>? actions;

  const AppbarWidget({
    super.key,
    required this.title,
    this.backgroundColor,
    this.titleColor,
    this.elevation,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? AppColors.green,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: elevation ?? 5,
      backgroundColor: backgroundColor ?? AppColors.white,
      leading: leading,
      actions: actions,
      iconTheme: IconThemeData(color: AppColors.green),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
