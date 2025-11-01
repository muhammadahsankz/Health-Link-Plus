import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:health_link_plus/utils/app_colors.dart';

/// Custom enum because delightful_toast does NOT provide one
enum ToastType { success, error, info }

class ToastWidget {
  static void show(
    BuildContext context, {
    required String message,
    String? subtitle,
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    IconData icon;
    Color color;

    switch (type) {
      case ToastType.success:
        icon = Icons.check_circle;
        color = AppColors.green;
        break;
      case ToastType.error:
        icon = Icons.error_outline;
        color = AppColors.red;
        break;
      case ToastType.info:
        icon = Icons.info_outline;
        color = AppColors.blue;
        break;
    }

    DelightToastBar(
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: duration,
      builder: (context) {
        return ToastCard(
          color: color,
          leading: Icon(icon, color: AppColors.white),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.white),
                ),
              ],
            ],
          ),
        );
      },
    ).show(context);
  }
}
