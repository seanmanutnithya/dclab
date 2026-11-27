import 'package:flutter/material.dart';

import '../theme/colors.dart';

// One big button with a title and a small line under it.
class ControlButton extends StatelessWidget {
  const ControlButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    this.borderColor = ThemeColor.border,
    this.onTap,
    this.expand = false,
  });

  final String title;
  final String subtitle; // the gamepad button, like "Back" or "Y"
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: expand ? null : 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: ThemeColor.textDim),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// All the robot buttons together.
// When a button is tapped we call onCommand with a short command name.
class RobotControls extends StatelessWidget {
  const RobotControls({
    super.key,
    required this.onCommand,
    this.expand = false,
  });

  final void Function(String command) onCommand;
  final bool expand;

  static const Color darkButton = Color(0xFF1F232B);
  static const Color greenButton = Color(0xFF166534);
  static const Color redButton = Color(0xFF991B1B);

  @override
  Widget build(BuildContext context) {
    Widget buttonRow(ControlButton left, ControlButton right) {
      return Row(
        crossAxisAlignment: expand
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.center,
        children: [
          Expanded(child: left),
          const SizedBox(width: 8),
          Expanded(child: right),
        ],
      );
    }

    Widget fillHeight(Widget child) {
      return expand ? Expanded(child: child) : child;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fillHeight(
          buttonRow(
            ControlButton(
              title: 'Start',
              subtitle: 'Back',
              color: greenButton,
              borderColor: ThemeColor.green,
              onTap: () => onCommand('start'),
              expand: expand,
            ),
            ControlButton(
              title: 'Retry',
              subtitle: 'M1',
              color: greenButton,
              borderColor: ThemeColor.green,
              onTap: () => onCommand('retry'),
              expand: expand,
            ),
          ),
        ),
        const SizedBox(height: 8),
        fillHeight(
          buttonRow(
            ControlButton(
              title: 'Start mechanism',
              subtitle: 'Start',
              color: darkButton,
              onTap: () => onCommand('start_mechanism'),
              expand: expand,
            ),
            ControlButton(
              title: 'Reset mechanism',
              subtitle: 'Y',
              color: redButton,
              borderColor: ThemeColor.red,
              onTap: () => onCommand('reset_mechanism'),
              expand: expand,
            ),
          ),
        ),
        const SizedBox(height: 8),
        fillHeight(
          buttonRow(
            ControlButton(
              title: 'Init odom',
              subtitle: 'A',
              color: darkButton,
              onTap: () => onCommand('init_odom'),
              expand: expand,
            ),
            ControlButton(
              title: 'Init odom retry',
              subtitle: 'M2',
              color: darkButton,
              onTap: () => onCommand('init_odom_retry'),
              expand: expand,
            ),
          ),
        ),
        const SizedBox(height: 8),
        fillHeight(
          GestureDetector(
            onTapDown: (_) => onCommand('hold_y'),
            onTapUp: (_) => onCommand('release_y'),
            onTapCancel: () => onCommand('release_y'),
            child: ControlButton(
              title: 'Initialization: hold',
              subtitle: 'hold Y',
              color: darkButton,
              expand: expand,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Init odom / Init odom retry work in STOP (press Reset mechanism first).',
          style: TextStyle(fontSize: 12, color: ThemeColor.textDim),
        ),
      ],
    );
  }
}
