import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/utils/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double width;
  final bool isOutlined;
  final double textSize;
  final Color? borderColor;

  // ✅ Loading Support
  final RxBool? isLoading;
  final double loaderSize;
  final double loaderStrokeWidth;
  final Color? loaderColor;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.blue,
    this.textColor = AppColors.white,
    this.borderRadius = 100,
    this.height = 40,
    this.width = 200,
    this.isOutlined = false,
    this.textSize = 14,
    this.borderColor,
    this.isLoading, // Optional
    this.loaderSize = 20,
    this.loaderStrokeWidth = 2,
    this.loaderColor,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ If isLoading is provided, use Obx. Otherwise build normally.
    if (isLoading != null) {
      return Obx(() => _buildButton(isLoading!.value));
    } else {
      return _buildButton(false);
    }
  }

  Widget _buildButton(bool loading) {
    return InkWell(
      onTap: loading ? null : onPressed,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.5)
              : Border(),
          boxShadow: isOutlined
              ? []
              : [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: loading
            ? SizedBox(
                height: loaderSize,
                width: loaderSize,
                child: CircularProgressIndicator(
                  strokeWidth: loaderStrokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    loaderColor ?? textColor,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: isOutlined ? color : textColor,
                  fontSize: textSize,
                ),
              ),
      ),
    );
  }
}
