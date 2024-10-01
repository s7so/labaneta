import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading; // إضافة هذه الخاصية

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false, // إضافة قيمة افتراضية
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // تعطيل الزر أثناء التحميل
      style: isOutlined
          ? ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: theme.colorScheme.secondary,
              side: BorderSide(color: theme.colorScheme.secondary),
            )
          : null,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOutlined ? theme.colorScheme.secondary : Colors.white,
                ),
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isOutlined ? theme.colorScheme.secondary : Colors.white,
              ),
            ),
    );
  }
}