import 'package:flutter/material.dart';

import '../theme/colors.dart';

// The choices for what a block can be.
// '?' means "not set yet". Change these names to match your game rules.
const List<String> blockTypeChoices = ['?', 'Red', 'Blue', 'Fake'];

// One earth block on the field.
// x and y are between 0 and 1:
//   x: 0 = left edge,  1 = right edge
//   y: 0 = top edge,   1 = bottom edge
class BlockPosition {
  const BlockPosition(this.name, this.x, this.y);

  final String name;
  final double x;
  final double y;
}

// The 10 earth blocks, placed like in your web field.
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

// The color of a block square depends on its type.
Color colorForType(String type) {
  if (type == 'Red') return ThemeColor.fieldRed;
  if (type == 'Blue') return ThemeColor.fieldBlue;
  if (type == 'Fake') return const Color(0xFF374151);
  return const Color(0xFF6B7280); // '?' = unknown
}

// A small grid of cubes, like the block stacks in the top corners.
class _CubeStack extends StatelessWidget {
  const _CubeStack({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          for (int row = 0; row < 2; row++)
            Expanded(
              child: Row(
                children: [
                  for (int col = 0; col < 5; col++)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(0.8),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color: const Color(0x44FFFFFF),
                            width: 0.6,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Horizontal stripes that look like steps going up.
class _Steps extends StatelessWidget {
  const _Steps({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < 6; i++)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.lerp(color, Colors.white, i * 0.05),
                border: const Border(
                  bottom: BorderSide(color: Color(0x33000000), width: 1),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// The field picture with the tappable blocks on top.
class GameField extends StatelessWidget {
  const GameField({
    super.key,
    required this.blockTypes,
    required this.selectedBlock,
    required this.onBlockTap,
    this.fillAvailable = false,
  });

  final Map<String, String> blockTypes; // example: {'l1': 'Red'}
  final String? selectedBlock; // null = nothing selected
  final void Function(String name) onBlockTap;
  final bool fillAvailable;

  @override
  Widget build(BuildContext context) {
    final field = Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xFFC9A79B),
        border: Border.all(color: const Color(0xFFB8892B), width: 4),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          final h = box.maxHeight;

          // Draws a colored shape. x, y, width, height are between 0 and 1.
          Widget zone({
            required double x,
            required double y,
            required double width,
            required double height,
            required Color color,
            Color? borderColor,
            double radius = 0,
            BoxShape shape = BoxShape.rectangle,
            bool shadow = false,
            Widget? child,
          }) {
            return Positioned(
              left: x * w,
              top: y * h,
              width: width * w,
              height: height * h,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: color,
                  shape: shape,
                  borderRadius: shape == BoxShape.circle
                      ? null
                      : BorderRadius.circular(radius),
                  border: borderColor == null
                      ? null
                      : Border.all(color: borderColor, width: 1.5),
                  boxShadow: shadow
                      ? const [
                          BoxShadow(
                            color: Color(0x55000000),
                            blurRadius: 6,
                            offset: Offset(2, 3),
                          ),
                        ]
                      : null,
                ),
                child: child,
              ),
            );
          }

          // Draws one tappable earth block.
          Widget blockButton(BlockPosition b) {
            final type = blockTypes[b.name] ?? '?';
            final isSelected = selectedBlock == b.name;

            return Positioned(
              left: b.x * w - 20,
              top: b.y * h - 36,
              width: 40,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onBlockTap(b.name),
                // The selected block grows a little.
                child: AnimatedScale(
                  scale: isSelected ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ThemeColor.blue
                              : const Color(0xDDFFFFFF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          b.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      // The block itself
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorForType(type),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: isSelected ? ThemeColor.blue : Colors.white,
                            width: isSelected ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xAA3B82F6)
                                  : const Color(0x66000000),
                              blurRadius: isSelected ? 10 : 4,
                              offset: isSelected
                                  ? Offset.zero
                                  : const Offset(1, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          type.substring(0, 1), // '?', 'R', 'B', 'F'
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Stack(
            children: [
              // Floor: red half and blue half, with a line in the middle
              zone(
                x: 0,
                y: 0,
                width: 0.5,
                height: 1,
                color: const Color(0xFFC9A79B),
              ),
              zone(
                x: 0.5,
                y: 0,
                width: 0.5,
                height: 1,
                color: const Color(0xFFA9C4C3),
              ),
              zone(
                x: 0.498,
                y: 0,
                width: 0.004,
                height: 1,
                color: const Color(0x66000000),
              ),

              // Steps on the left and right side
              zone(
                x: 0.11,
                y: 0.30,
                width: 0.12,
                height: 0.55,
                color: const Color(0xFFB08F82),
                shadow: true,
                child: const _Steps(color: Color(0xFFB08F82)),
              ),
              zone(
                x: 0.77,
                y: 0.30,
                width: 0.12,
                height: 0.55,
                color: const Color(0xFF8FB0AE),
                shadow: true,
                child: const _Steps(color: Color(0xFF8FB0AE)),
              ),

              // Block stacks in the top corners (5 x 2 cubes)
              zone(
                x: 0.02,
                y: 0.02,
                width: 0.20,
                height: 0.11,
                color: const Color(0xFF8E2B2B),
                radius: 2,
                shadow: true,
                child: const _CubeStack(color: Color(0xFFB03A3A)),
              ),
              zone(
                x: 0.78,
                y: 0.02,
                width: 0.20,
                height: 0.11,
                color: const Color(0xFF3A1A8F),
                radius: 2,
                shadow: true,
                child: const _CubeStack(color: Color(0xFF5B2FD0)),
              ),

              // Start areas (top and bottom, middle) with a post at the top
              zone(
                x: 0.45,
                y: 0.09,
                width: 0.09,
                height: 0.11,
                color: const Color(0xFFD9CDB0),
                borderColor: const Color(0xFFB8892B),
                radius: 3,
                shadow: true,
              ),
              zone(
                x: 0.475,
                y: 0.12,
                width: 0.04,
                height: 0.036,
                color: const Color(0xFF3B2A1A),
                shape: BoxShape.circle,
              ),
              zone(
                x: 0.45,
                y: 0.89,
                width: 0.09,
                height: 0.08,
                color: const Color(0xFFD9CDB0),
                borderColor: const Color(0xFFB8892B),
                radius: 3,
                shadow: true,
              ),

              // Small red and blue squares
              zone(
                x: 0.33,
                y: 0.26,
                width: 0.06,
                height: 0.07,
                color: const Color(0xFFB23A3A),
                borderColor: const Color(0xFF7A1F1F),
                radius: 2,
                shadow: true,
              ),
              zone(
                x: 0.59,
                y: 0.26,
                width: 0.06,
                height: 0.07,
                color: const Color(0xFF3A1FB2),
                borderColor: const Color(0xFF24107A),
                radius: 2,
                shadow: true,
              ),

              // Center platform with a post in the middle
              zone(
                x: 0.36,
                y: 0.39,
                width: 0.27,
                height: 0.31,
                color: const Color(0xFFBDB6A5),
                borderColor: const Color(0xFF9C9482),
                radius: 3,
                shadow: true,
              ),
              zone(
                x: 0.47,
                y: 0.52,
                width: 0.05,
                height: 0.045,
                color: const Color(0xFF3B2A1A),
                shape: BoxShape.circle,
                shadow: true,
              ),

              // Yellow squares
              zone(
                x: 0.145,
                y: 0.63,
                width: 0.085,
                height: 0.10,
                color: const Color(0xFFF2D45C),
                borderColor: const Color(0xFFB8892B),
                radius: 2,
                shadow: true,
              ),
              zone(
                x: 0.765,
                y: 0.63,
                width: 0.085,
                height: 0.10,
                color: const Color(0xFFF6DE9A),
                borderColor: const Color(0xFF6B4FB0),
                radius: 2,
                shadow: true,
              ),

              // The earth blocks go on top of everything
              for (final b in allBlocks) blockButton(b),
            ],
          );
        },
      ),
    );

    return fillAvailable
        ? SizedBox.expand(child: field)
        : AspectRatio(aspectRatio: 0.9, child: field);
  }
}

// Under the field: what each block color means, and how many are set.
class FieldLegend extends StatelessWidget {
  const FieldLegend({super.key, required this.blockTypes});

  final Map<String, String> blockTypes;

  @override
  Widget build(BuildContext context) {
    // Count the blocks that are not '?'.
    final setCount = blockTypes.values.where((type) => type != '?').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 14,
          runSpacing: 6,
          children: [
            for (final type in blockTypeChoices)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colorForType(type),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    type == '?' ? 'Not set' : type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ThemeColor.textDim,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$setCount / ${blockTypes.length} blocks set',
          style: const TextStyle(fontSize: 12, color: ThemeColor.textDim),
        ),
      ],
    );
  }
}
