import 'package:flutter/material.dart';

import '../components/app_card.dart';

// The "Testing" tab: switch the status pills on and off by hand
// so you can see how the app looks without a real robot.
class TestingTab extends StatelessWidget {
  const TestingTab({
    super.key,
    required this.lidarOn,
    required this.gamepadOn,
    required this.robotConnected,
    required this.onLidarChanged,
    required this.onGamepadChanged,
    required this.onRobotChanged,
    required this.onSend,
  });

  final bool lidarOn;
  final bool gamepadOn;
  final bool robotConnected;
  final void Function(bool value) onLidarChanged;
  final void Function(bool value) onGamepadChanged;
  final void Function(bool value) onRobotChanged;
  final Future<void> Function(String command) onSend;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        AppCard(
          title: 'Fake status',
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('LiDAR has data'),
                value: lidarOn,
                onChanged: onLidarChanged,
              ),
              SwitchListTile(
                title: const Text('Gamepad on'),
                value: gamepadOn,
                onChanged: onGamepadChanged,
              ),
              SwitchListTile(
                title: const Text('Robot connected'),
                value: robotConnected,
                onChanged: onRobotChanged,
              ),
            ],
          ),
        ),
        AppCard(
          title: 'Test command',
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () => onSend('ping'),
              child: const Text('Send "ping"'),
            ),
          ),
        ),
      ],
    );
  }
}
