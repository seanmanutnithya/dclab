import 'package:flutter/material.dart';

import '../theme/colors.dart';

class MessageBar extends StatelessWidget {
  const MessageBar({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(12, isLandscape ? 8 : 12, 12, 0),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: isLandscape ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF14264B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2F55A4)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: ThemeColor.white, fontSize: 13),
      ),
    );
  }
}
