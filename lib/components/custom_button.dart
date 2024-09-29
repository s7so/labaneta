import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: isOutlined
          ? ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: theme.colorScheme.secondary,
              side: BorderSide(color: theme.colorScheme.secondary),
            )
          : null,
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: isOutlined ? theme.colorScheme.secondary : Colors.white,
        ),
      ),
    );
  }
}