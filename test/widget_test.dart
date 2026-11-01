import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todolist_c/app.dart';

void main() {
  // Fungsi bantu: mengetik teks di kolom input.
  Future<void> typeTask(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
  }

  Future<void> tapAddButton(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Tambah tugas'));
    // pump() menggambar ulang layar setelah setState.
    await tester.pump();
  }

  testWidgets('Tampilan kosong muncul saat belum ada tugas', (tester) async {
    await tester.pumpWidget(const TodoApp());

    expect(find.text('Daftar Tugas'), findsOneWidget);
    expect(find.text('Belum ada tugas. Yuk tambahkan!'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNothing);
  });

  testWidgets('Menambah tugas lewat tombol', (tester) async {
    await tester.pumpWidget(const TodoApp());

    await typeTask(tester, 'Belajar Flutter');
    await tapAddButton(tester);

    expect(
      find.widgetWithText(CheckboxListTile, 'Belajar Flutter'),
      findsOneWidget,
    );
    expect(find.text('Belum ada tugas. Yuk tambahkan!'), findsNothing);

    // Kolom input dikosongkan lagi.
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, isEmpty);
  });

  testWidgets('Menambah tugas lewat Enter', (tester) async {
    await tester.pumpWidget(const TodoApp());

    await typeTask(tester, 'Belanja');
    // Meniru menekan tombol "selesai"/Enter di keyboard.
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.widgetWithText(CheckboxListTile, 'Belanja'), findsOneWidget);
  });

  testWidgets('Tugas baru muncul paling atas dan spasi dibuang', (
    tester,
  ) async {
    await tester.pumpWidget(const TodoApp());

    await typeTask(tester, 'Pertama');
    await tapAddButton(tester);
    await typeTask(tester, '   Kedua   ');
    await tapAddButton(tester);

    final titles = tester
        .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
        .map((tile) => (tile.title! as Text).data)
        .toList();
    expect(titles, ['Kedua', 'Pertama']);
  });

  testWidgets('Input kosong atau hanya spasi diabaikan', (tester) async {
    await tester.pumpWidget(const TodoApp());

    await tapAddButton(tester);
    await typeTask(tester, '    ');
    await tapAddButton(tester);

    expect(find.byType(CheckboxListTile), findsNothing);
    expect(find.text('Belum ada tugas. Yuk tambahkan!'), findsOneWidget);
  });

  testWidgets('Mengetuk checkbox mengubah status tugas', (tester) async {
    await tester.pumpWidget(const TodoApp());
    await typeTask(tester, 'Olahraga');
    await tapAddButton(tester);

    bool isChecked() =>
        tester.widget<Checkbox>(find.byType(Checkbox)).value ?? false;
    TextDecoration? decoration() =>
        tester.widget<Text>(find.text('Olahraga')).style?.decoration;

    expect(isChecked(), isFalse);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(isChecked(), isTrue);
    expect(decoration(), TextDecoration.lineThrough);

    // Ketuk lagi untuk membatalkan centang.
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(isChecked(), isFalse);
    expect(decoration(), isNull);
  });

  testWidgets('Menggeser tugas menghapusnya dan memunculkan SnackBar', (
    tester,
  ) async {
    await tester.pumpWidget(const TodoApp());
    await typeTask(tester, 'Cuci piring');
    await tapAddButton(tester);

    // Geser dari kanan ke kiri, lalu tunggu semua animasi selesai.
    await tester.drag(find.text('Cuci piring'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.byType(CheckboxListTile), findsNothing);
    expect(find.text('Tugas "Cuci piring" dihapus'), findsOneWidget);
  });
}
