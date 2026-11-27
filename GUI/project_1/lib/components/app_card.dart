import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.title,
    this.margin = const EdgeInsets.only(bottom: 12),
    this.expandChild = false,
  });

  final Widget child;
  final String? title;
  final EdgeInsetsGeometry? margin;
  final bool expandChild;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColor.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.white,
                ),
              ),
            ),
          if (expandChild) Expanded(child: child) else child,
        ],
      ),
    );
  }
}
