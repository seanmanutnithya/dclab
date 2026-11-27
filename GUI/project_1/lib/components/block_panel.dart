import 'package:flutter/material.dart';

import '../theme/colors.dart';

class BlockPanel extends StatelessWidget {
  const BlockPanel({
    super.key,
    required this.selectedBlock,
    required this.selectedType,
    required this.onTypeChosen,
    required this.onSend,
  });

  final String? selectedBlock;
  final String selectedType;
  final void Function(String type) onTypeChosen;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tap an earth block on the field',
          style: const TextStyle(color: ThemeColor.textDim),
        ),
      ],
    );
  }
}
