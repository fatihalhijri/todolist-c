import 'package:flutter_test/flutter_test.dart';

import 'package:todolist_c/app.dart';

void main() {
  testWidgets('Aplikasi tampil dengan judul "Daftar Tugas"', (tester) async {
    // pumpWidget "menggambar" widget di layar uji (tanpa HP sungguhan).
    await tester.pumpWidget(const TodoApp());

    expect(find.text('Daftar Tugas'), findsOneWidget);
    expect(find.text('Belum ada tugas'), findsOneWidget);
  });
}
