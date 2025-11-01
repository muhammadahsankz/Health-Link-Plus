import 'package:flutter/material.dart';
import 'package:health_link_plus/utils/app_colors.dart';

enum MessageType { error, success, warning, info }

class MessageAlertWidget extends StatelessWidget {
  final String message;
  final MessageType type;
  final double width;

  const MessageAlertWidget({
    super.key,
    required this.message,
    required this.type,
    this.width = double.infinity,
  });

  // 🎨 Define colors and icons for each type
  (Color, IconData) _getStyle() {
    switch (type) {
      case MessageType.success:
        return (AppColors.green, Icons.check_circle_outline);
      case MessageType.warning:
        return (AppColors.orange, Icons.warning_amber_rounded);
      case MessageType.info:
        return (AppColors.blue, Icons.info_outline);
      case MessageType.error:
      // ignore: unreachable_switch_default
      default:
        return (AppColors.red, Icons.error_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _getStyle();

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.05),
            color.withValues(alpha: 0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 40),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
