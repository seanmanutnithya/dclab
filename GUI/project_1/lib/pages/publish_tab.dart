import 'package:flutter/material.dart';

import '../components/app_card.dart';
import '../components/block_panel.dart';
import '../components/game_field.dart';
import '../components/robot_controls.dart';

class PublishTab extends StatefulWidget {
  const PublishTab({super.key, required this.onSend, required this.onMessage});

  final Future<void> Function(String command) onSend;
  final void Function(String text) onMessage;

  @override
  State<PublishTab> createState() => _PublishTabState();
}

class _PublishTabState extends State<PublishTab> {
  String? selectedBlock;

  final Map<String, String> blockTypes = {
    for (final b in allBlocks) b.name: '?',
  };

  void selectBlock(String name) {
    setState(() {
      selectedBlock = name;
    });
    widget.onMessage('Block $name selected. Pick a type, then Send to robot.');
  }

  void chooseType(String type) {
    final name = selectedBlock;
    if (name == null) return;

    setState(() {
      blockTypes[name] = type;
    });
  }

  void sendBlock() {
    final name = selectedBlock;
    if (name == null) return;

    final type = blockTypes[name] ?? '?';
    widget.onSend('block $name = $type');
  }

  @override
  Widget build(BuildContext context) {
    final name = selectedBlock;
    final selectedType = name == null ? '?' : (blockTypes[name] ?? '?');
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: AppCard(
                margin: EdgeInsets.zero,
                expandChild: true,
                child: Center(
                  child: GameField(
                    blockTypes: blockTypes,
                    selectedBlock: selectedBlock,
                    onBlockTap: selectBlock,
                    fillAvailable: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: AppCard(
                      title: 'Robot control',
                      expandChild: true,
                      child: RobotControls(
                        onCommand: widget.onSend,
                        expand: true,
                      ),
                    ),
                  ),
                  AppCard(
                    child: BlockPanel(
                      selectedBlock: selectedBlock,
                      selectedType: selectedType,
                      onTypeChosen: chooseType,
                      onSend: sendBlock,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        AppCard(
          child: GameField(
            blockTypes: blockTypes,
            selectedBlock: selectedBlock,
            onBlockTap: selectBlock,
          ),
        ),
        AppCard(
          title: 'Earth block',
          child: BlockPanel(
            selectedBlock: selectedBlock,
            selectedType: selectedType,
            onTypeChosen: chooseType,
            onSend: sendBlock,
          ),
        ),
        AppCard(
          title: 'Robot control',
          child: RobotControls(onCommand: widget.onSend),
        ),
      ],
    );
  }
}
