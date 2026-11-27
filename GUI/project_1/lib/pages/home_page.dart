import 'package:flutter/material.dart';

import '../components/message_bar.dart';
import '../components/navbar.dart';
import '../services/robot_service.dart';
import 'publish_tab.dart';
import 'setting_tab.dart';
import 'testing_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RobotService robot = RobotService();

  int selectedTab = 0;
  static const List<String> tabHints = [
    'Publish: tap an earth block, then Send to robot.',
    'Setting: configure the robot address and port.',
    'Testing: adjust simulated status and send a test command.',
  ];
  String message = tabHints[0];

  bool lidarOn = false;
  bool gamepadOn = false;
  bool robotConnected = true;

  void showMessage(String text) {
    setState(() {
      message = text;
    });
  }

  Future<void> sendToRobot(String command) async {
    final reply = await robot.sendCommand(command);

    if (!mounted) return;
    showMessage(reply);
  }

  void changeTab(int index) {
    setState(() {
      selectedTab = index;
      message = tabHints[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Navbar(
              selectedTab: selectedTab,
              onTabSelected: changeTab,
              lidarOn: lidarOn,
              gamepadOn: gamepadOn,
              robotConnected: robotConnected,
            ),
            MessageBar(message: message),
            Expanded(
              child: IndexedStack(
                index: selectedTab,
                children: [
                  PublishTab(onSend: sendToRobot, onMessage: showMessage),
                  SettingTab(robot: robot, onMessage: showMessage),
                  TestingTab(
                    lidarOn: lidarOn,
                    gamepadOn: gamepadOn,
                    robotConnected: robotConnected,
                    onLidarChanged: (value) => setState(() => lidarOn = value),
                    onGamepadChanged: (value) =>
                        setState(() => gamepadOn = value),
                    onRobotChanged: (value) =>
                        setState(() => robotConnected = value),
                    onSend: sendToRobot,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
