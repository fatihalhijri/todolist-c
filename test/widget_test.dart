import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

import 'package:todolist_c/app.dart';

/// Penyimpanan tiruan yang selalu gagal saat menulis.
///
/// Wajib `final class` karena kelas induknya bertanda `base`: aturan Dart 3
/// agar turunannya tidak bisa diturunkan lagi sembarangan.
final class _FailingPreferences extends InMemorySharedPreferencesAsync {
  _FailingPreferences() : super.empty();

  @override
  Future<bool> setString(
    String key,
    String value,
    SharedPreferencesOptions options,
  ) async {
    throw Exception('Penyimpanan penuh');
  }
}

void main() {
  // Setiap tes mulai dengan penyimpanan tiruan yang kosong.
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  // Membuka aplikasi lalu menunggu sampai pemuatan data selesai.
  // pumpAndSettle menggambar ulang terus sampai tidak ada lagi yang berubah.
  Future<void> startApp(WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
  }

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
    await startApp(tester);

    expect(find.text('Daftar Tugas'), findsOneWidget);
    expect(find.text('Belum ada tugas. Yuk tambahkan!'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNothing);
  });

  testWidgets('Menambah tugas lewat tombol', (tester) async {
    await startApp(tester);

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
    await startApp(tester);

    await typeTask(tester, 'Belanja');
    // Meniru menekan tombol "selesai"/Enter di keyboard.
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.widgetWithText(CheckboxListTile, 'Belanja'), findsOneWidget);
  });

  testWidgets('Tugas baru muncul paling atas dan spasi dibuang', (
    tester,
  ) async {
    await startApp(tester);

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
    await startApp(tester);

    await tapAddButton(tester);
    await typeTask(tester, '    ');
    await tapAddButton(tester);

    expect(find.byType(CheckboxListTile), findsNothing);
    expect(find.text('Belum ada tugas. Yuk tambahkan!'), findsOneWidget);
  });

  testWidgets('Mengetuk checkbox mengubah status tugas', (tester) async {
    await startApp(tester);
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
    await startApp(tester);
    await typeTask(tester, 'Cuci piring');
    await tapAddButton(tester);

    // Geser dari kanan ke kiri, lalu tunggu semua animasi selesai.
    await tester.drag(find.text('Cuci piring'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.byType(CheckboxListTile), findsNothing);
    expect(find.text('Tugas "Cuci piring" dihapus'), findsOneWidget);
  });

  testWidgets('Indikator loading muncul saat data sedang dimuat', (
    tester,
  ) async {
    await tester.pumpWidget(const TodoApp());

    // Frame pertama: data belum selesai dimuat.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(TextField), findsNothing);

    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Tugas dan statusnya masih ada setelah aplikasi dibuka ulang', (
    tester,
  ) async {
    await startApp(tester);
    await typeTask(tester, 'Belajar Flutter');
    await tapAddButton(tester);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    // "Menutup" aplikasi dengan mengganti seluruh layar, lalu membukanya lagi.
    await tester.pumpWidget(const SizedBox());
    await startApp(tester);

    expect(find.text('Belajar Flutter'), findsOneWidget);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
  });

  testWidgets('SnackBar muncul jika penyimpanan gagal', (tester) async {
    SharedPreferencesAsyncPlatform.instance = _FailingPreferences();
    await startApp(tester);

    await typeTask(tester, 'Belanja');
    await tapAddButton(tester);
    await tester.pumpAndSettle();

    // Tugas tetap tampil walaupun gagal disimpan.
    expect(find.text('Belanja'), findsOneWidget);
    expect(find.text('Gagal menyimpan tugas'), findsOneWidget);
  });
}
