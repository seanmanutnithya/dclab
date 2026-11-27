import 'package:flutter/material.dart';

import '../theme/colors.dart';

class BlockPosition {
  const BlockPosition(this.name, this.x, this.y);

  final String name;
  final double x;
  final double y;
}

const List<BlockPosition> allBlocks = [
  BlockPosition('r2', 0.254, 0.286),
  BlockPosition('s2', 0.492, 0.282),
  BlockPosition('b2', 0.733, 0.280),
  BlockPosition('l2', 0.383, 0.423),
  BlockPosition('l1', 0.606, 0.423),
  BlockPosition('l3', 0.383, 0.673),
  BlockPosition('l4', 0.606, 0.671),
  BlockPosition('r1', 0.254, 0.816),
  BlockPosition('s1', 0.497, 0.816),
  BlockPosition('b1', 0.738, 0.814),
];

Color colorForType(String type) {
  if (type == 'Red') return ThemeColor.fieldRed;
  if (type == 'Blue') return ThemeColor.fieldBlue;
  if (type == 'Fake') return const Color(0xFF374151);
  return const Color(0xFF6B7280);
}

class GameField extends StatelessWidget {
  const GameField({
    super.key,
    required this.blockTypes,
    required this.selectedBlock,
    required this.onBlockTap,
  });

  final Map<String, String> blockTypes;
  final String? selectedBlock;
  final void Function(String name) onBlockTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.9,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFB8892B), width: 3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth;
            final h = box.maxHeight;
            final scale = (w / 340).clamp(0.65, 1.0);
            final boxSize = 32.0 * scale;
            final buttonWidth = 38.0 * scale;
            final labelFontSize = (11.0 * scale).clamp(8.5, 11.0);
            final labelSpacing = 2.0 * scale;
            final topOffset = labelFontSize + labelSpacing + (boxSize / 2) + 2;

            Widget zone(
              double x,
              double y,
              double width,
              double height,
              Color color,
            ) {
              return Positioned(
                left: x * w,
                top: y * h,
                width: width * w,
                height: height * h,
                child: Container(color: color),
              );
            }

            Widget blockButton(BlockPosition b) {
              final type = blockTypes[b.name] ?? '?';
              final isSelected = selectedBlock == b.name;

              return Positioned(
                left: b.x * w - (buttonWidth / 2),
                top: b.y * h - topOffset,
                width: buttonWidth,
                child: GestureDetector(
                  onTap: () => onBlockTap(b.name),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        b.name,
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: labelSpacing),
                      Container(
                        width: boxSize,
                        height: boxSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorForType(type),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSelected ? ThemeColor.blue : Colors.white,
                            width: isSelected ? 3 : 2,
                          ),
                        ),
                        child: Text(
                          type.substring(0, 1),
                          style: TextStyle(
                            fontSize: 13.0 * scale,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Stack(
              children: [
                zone(0, 0, 0.5, 1, const Color(0xFFC9A79B)),
                zone(0.5, 0, 0.5, 1, const Color(0xFFA9C4C3)),
                zone(0.02, 0.02, 0.18, 0.10, const Color(0xFFB03A3A)),
                zone(0.80, 0.02, 0.18, 0.10, const Color(0xFF4B22B8)),
                zone(0.45, 0.10, 0.09, 0.10, const Color(0xFFD9CDB0)),
                zone(0.45, 0.89, 0.09, 0.08, const Color(0xFFD9CDB0)),
                zone(0.33, 0.26, 0.06, 0.07, const Color(0xFFB23A3A)),
                zone(0.59, 0.26, 0.06, 0.07, const Color(0xFF3A1FB2)),
                zone(0.36, 0.39, 0.27, 0.31, const Color(0xFFBDB6A5)),
                zone(0.145, 0.63, 0.085, 0.10, const Color(0xFFF2D45C)),
                zone(0.765, 0.63, 0.085, 0.10, const Color(0xFFF6DE9A)),
                for (final b in allBlocks) blockButton(b),
              ],
            );
          },
        ),
      ),
    );
  }
}
