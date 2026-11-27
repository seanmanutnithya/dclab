import 'package:flutter/material.dart';

import '../components/app_card.dart';
import '../services/robot_service.dart';

// The "Setting" tab: change the robot's IP address and port.
class SettingTab extends StatefulWidget {
  const SettingTab({super.key, required this.robot, required this.onMessage});

  final RobotService robot;
  final void Function(String text) onMessage;

  @override
  State<SettingTab> createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  // A controller reads and writes the text inside a TextField.
  late final TextEditingController ipController;
  late final TextEditingController portController;

  @override
  void initState() {
    super.initState();
    ipController = TextEditingController(text: widget.robot.ip);
    portController = TextEditingController(text: widget.robot.port);
  }

  @override
  void dispose() {
    // Clean up when this page is closed.
    ipController.dispose();
    portController.dispose();
    super.dispose();
  }

  void save() {
    widget.robot.ip = ipController.text.trim();
    widget.robot.port = portController.text.trim();
    widget.onMessage(
      'Saved. Robot address: ${widget.robot.ip}:${widget.robot.port}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        AppCard(
          title: 'Robot address',
          child: Column(
            children: [
              TextField(
                controller: ipController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'IP address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: portController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(onPressed: save, child: const Text('Save')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
