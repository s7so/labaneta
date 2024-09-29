import 'package:flutter/material.dart';
import 'package:labaneta_sweet/utils/app_theme.dart';
import 'package:labaneta_sweet/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: isOutlined
          ? ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppTheme.accentColor,
              side: BorderSide(color: AppTheme.accentColor),
            )
          : null,
      child: Text(
        text,
        style: AppTheme.textTheme.labelLarge?.copyWith(
          color: isOutlined ? AppTheme.accentColor : Colors.white,
        ),
      ),
    );
  }
}