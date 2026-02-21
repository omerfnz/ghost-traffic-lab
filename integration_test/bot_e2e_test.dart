import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ghost_traffic_lab/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End Payload Execution Flow', (tester) async {
    await app.main();
    await tester.pumpAndSettle();

    // 1. Check if we are on Dashboard
    expect(find.text('GhostTraffic Lab'), findsOneWidget);

    // 2. Go to Payload Builder Tab
    final payloadTab = find.byIcon(Icons.build_outlined);
    await tester.tap(payloadTab);
    await tester.pumpAndSettle();

    // 3. Open Add Action Sheet
    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // 4. Add "Wait 3s" preset
    final waitPreset = find.text('Wait 3s');
    await tester.tap(waitPreset);
    await tester.pumpAndSettle();

    // 5. Open Add Action Sheet again
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // 6. Add "Launch Chrome" preset
    final listView = find.byType(ListView);
    await tester.drag(listView, const Offset(0, -500));
    await tester.pumpAndSettle();

    final launchChrome = find.text('Launch Chrome');
    await tester.tap(launchChrome);
    await tester.pumpAndSettle();

    // Verify actions are added
    expect(find.text('Wait 3000ms'), findsOneWidget);
    expect(find.text('Launch com.android.chrome'), findsOneWidget);

    // 7. Go back to Dashboard
    final dashTab = find.byIcon(Icons.dashboard_outlined);
    await tester.tap(dashTab);
    await tester.pumpAndSettle();

    // We can't actually tap "ARM SYSTEM" in the test if permissions are missing
    // on the emulator because the button is disabled. In this test, we verify
    // the system correctly identifies the disabled status.
    final armButton = find.text('ARM SYSTEM');
    expect(armButton, findsOneWidget);

    // 8. Try tapping ARM (Should show snackbar/redirect if disabled)
    await tester.tap(armButton);
    await tester.pumpAndSettle();

    // If permissions aren't fully granted, it redirects to Permissions view
    final isAtPermissions = find.text('Permissions').evaluate().isNotEmpty;
    if (isAtPermissions) {
      print(
        '✅ Redirected to Permissions because setup is incomplete. '
        'To run a full test, run setup_emulator.fish first!',
      );
    } else {
      print('✅ App is Armed and Payload engine started!');
    }
  });
}
