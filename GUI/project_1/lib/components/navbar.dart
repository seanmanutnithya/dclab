import 'package:flutter/material.dart';

import '../theme/colors.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.lidarOn,
    required this.gamepadOn,
    required this.robotConnected,
  });

  final int selectedTab;
  final void Function(int index) onTabSelected;
  final bool lidarOn;
  final bool gamepadOn;
  final bool robotConnected;

  static const List<String> tabs = ['Publish', 'Setting', 'Testing'];

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      return Container(
        color: ThemeColor.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Robocon 2027',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ThemeColor.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: Text(
                            'Earth Blocks',
                            style: TextStyle(
                              fontSize: 12,
                              color: ThemeColor.textDim,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Container(
                      height: 36,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ThemeColor.border,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < tabs.length; i++)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => onTabSelected(i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: selectedTab == i
                                      ? ThemeColor.blue
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  tabs[i],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: selectedTab == i
                                        ? ThemeColor.white
                                        : ThemeColor.textDim,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StatusPill(
                          label: lidarOn ? 'LiDAR: ok' : 'LiDAR: no data',
                          isGood: lidarOn,
                          compact: true,
                        ),
                        const SizedBox(width: 8),
                        StatusPill(
                          label: gamepadOn ? 'Gamepad on' : 'Gamepad off',
                          isGood: gamepadOn,
                          compact: true,
                        ),
                        const SizedBox(width: 8),
                        StatusPill(
                          label: robotConnected
                              ? 'Robot connected'
                              : 'Robot offline',
                          isGood: robotConnected,
                          compact: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      color: ThemeColor.black,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Robocon 2027',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.white,
                ),
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  'Earth Blocks',
                  style: TextStyle(color: ThemeColor.textDim),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ThemeColor.border,
            ),
            child: Row(
              children: [
                for (int i = 0; i < tabs.length; i++)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTabSelected(i),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: selectedTab == i
                              ? ThemeColor.blue
                              : Colors.transparent,
                        ),
                        child: Text(
                          tabs[i],
                          style: TextStyle(
                            color: selectedTab == i
                                ? ThemeColor.white
                                : ThemeColor.textDim,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                StatusPill(
                  label: lidarOn ? 'LiDAR: ok' : 'LiDAR: no data',
                  isGood: lidarOn,
                ),
                const SizedBox(width: 8),
                StatusPill(
                  label: gamepadOn ? 'Gamepad on' : 'Gamepad off',
                  isGood: gamepadOn,
                ),
                const SizedBox(width: 8),
                StatusPill(
                  label: robotConnected ? 'Robot connected' : 'Robot offline',
                  isGood: robotConnected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.isGood,
    this.compact = false,
  });

  final String label;
  final bool isGood;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: ThemeColor.faint,
        border: Border.all(color: ThemeColor.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: compact ? 8 : 10,
            width: compact ? 8 : 10,
            decoration: BoxDecoration(
              color: isGood ? ThemeColor.green : ThemeColor.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              color: ThemeColor.textDim,
            ),
          ),
        ],
      ),
    );
  }
}
