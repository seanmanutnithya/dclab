import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:project_1/components/game_field.dart';
import 'package:project_1/components/robot_controls.dart';
import 'package:project_1/pages/publish_tab.dart';

void main() {
  testWidgets('landscape publish layout fills field and control space', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PublishTab(onSend: (_) async {}, onMessage: (_) {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(GameField)).width, greaterThan(600));
    expect(
      tester.getSize(find.byType(ControlButton).first).height,
      greaterThan(64),
    );
  });
}
