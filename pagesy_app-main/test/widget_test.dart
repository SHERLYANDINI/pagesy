import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagesy_frontend/app/app.dart';

void main() {
  testWidgets('App menampilkan halaman login', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });
}