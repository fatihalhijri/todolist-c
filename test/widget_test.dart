import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

import 'package:todolist_c/app.dart';
import 'package:todolist_c/models/task_filter.dart';
import 'package:todolist_c/widgets/task_tile.dart';

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
    expect(find.byType(TaskTile), findsNothing);
  });

  testWidgets('Menambah tugas lewat tombol', (tester) async {
    await startApp(tester);

    await typeTask(tester, 'Belajar Flutter');
    await tapAddButton(tester);

    expect(find.widgetWithText(TaskTile, 'Belajar Flutter'), findsOneWidget);
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

    expect(find.widgetWithText(TaskTile, 'Belanja'), findsOneWidget);
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
        .widgetList<TaskTile>(find.byType(TaskTile))
        .map((tile) => tile.task.title)
        .toList();
    expect(titles, ['Kedua', 'Pertama']);
  });

  testWidgets('Input kosong atau hanya spasi diabaikan', (tester) async {
    await startApp(tester);

    await tapAddButton(tester);
    await typeTask(tester, '    ');
    await tapAddButton(tester);

    expect(find.byType(TaskTile), findsNothing);
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

    expect(find.byType(TaskTile), findsNothing);
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

  group('Fitur A: penghitung tugas', () {
    testWidgets('Tidak tampil saat daftar kosong', (tester) async {
      await startApp(tester);

      expect(find.textContaining('tugas belum selesai'), findsNothing);
    });

    testWidgets('Menghitung tugas yang belum selesai', (tester) async {
      await startApp(tester);
      await typeTask(tester, 'Satu');
      await tapAddButton(tester);
      await typeTask(tester, 'Dua');
      await tapAddButton(tester);

      expect(find.text('2 dari 2 tugas belum selesai'), findsOneWidget);

      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      expect(find.text('1 dari 2 tugas belum selesai'), findsOneWidget);
    });
  });

  group('Fitur B: filter', () {
    // Menyiapkan dua tugas: "Selesai dikerjakan" (dicentang) dan "Belum
    // dikerjakan". Tugas baru masuk paling atas, jadi yang dicentang
    // adalah baris kedua (.last).
    Future<void> addTwoTasks(WidgetTester tester) async {
      await typeTask(tester, 'Selesai dikerjakan');
      await tapAddButton(tester);
      await typeTask(tester, 'Belum dikerjakan');
      await tapAddButton(tester);
      await tester.tap(find.byType(Checkbox).last);
      await tester.pump();
    }

    Future<void> chooseFilter(WidgetTester tester, String label) async {
      // Cari teks di DALAM SegmentedButton; mengetuk SegmentedButton-nya
      // langsung akan mengenai bagian tengah (selalu tombol "Belum").
      await tester.tap(
        find.descendant(
          of: find.byType(SegmentedButton<TaskFilter>),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Tidak tampil saat daftar kosong', (tester) async {
      await startApp(tester);

      expect(find.byType(SegmentedButton<TaskFilter>), findsNothing);
    });

    testWidgets('Menampilkan tugas sesuai filter', (tester) async {
      await startApp(tester);
      await addTwoTasks(tester);

      await chooseFilter(tester, 'Belum');
      expect(find.text('Belum dikerjakan'), findsOneWidget);
      expect(find.text('Selesai dikerjakan'), findsNothing);

      await chooseFilter(tester, 'Selesai');
      expect(find.text('Belum dikerjakan'), findsNothing);
      expect(find.text('Selesai dikerjakan'), findsOneWidget);

      await chooseFilter(tester, 'Semua');
      expect(find.text('Belum dikerjakan'), findsOneWidget);
      expect(find.text('Selesai dikerjakan'), findsOneWidget);
    });

    testWidgets('Pesan muncul saat hasil filter kosong', (tester) async {
      await startApp(tester);
      await typeTask(tester, 'Belanja');
      await tapAddButton(tester);

      await chooseFilter(tester, 'Selesai');

      expect(find.text('Tidak ada tugas yang selesai'), findsOneWidget);
    });
  });

  group('Fitur C: edit tugas', () {
    Finder dialogField() => find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );

    // Membuat satu tugas lalu membuka dialog edit dengan mengetuk judulnya.
    Future<void> openEditDialog(WidgetTester tester, String title) async {
      await typeTask(tester, title);
      await tapAddButton(tester);
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
    }

    testWidgets('Dialog terisi judul lama, Simpan mengubah judul', (
      tester,
    ) async {
      await startApp(tester);
      await openEditDialog(tester, 'Belanja');

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        tester.widget<TextField>(dialogField()).controller!.text,
        'Belanja',
      );

      await tester.enterText(dialogField(), '  Belanja sayur  ');
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Belanja sayur'), findsOneWidget);
      // Mengetuk judul tidak ikut mencentang.
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
    });

    testWidgets('Batal tidak mengubah judul', (tester) async {
      await startApp(tester);
      await openEditDialog(tester, 'Belanja');

      await tester.enterText(dialogField(), 'Judul lain');
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(find.text('Belanja'), findsOneWidget);
      expect(find.text('Judul lain'), findsNothing);
    });

    testWidgets('Judul kosong tidak bisa disimpan', (tester) async {
      await startApp(tester);
      await openEditDialog(tester, 'Belanja');

      await tester.enterText(dialogField(), '   ');
      await tester.pump();

      final saveButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Simpan'),
      );
      expect(saveButton.onPressed, isNull);

      // Enter juga diabaikan; dialog tetap terbuka.
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Judul hasil edit tetap ada setelah dibuka ulang', (
      tester,
    ) async {
      await startApp(tester);
      await openEditDialog(tester, 'Belanja');
      await tester.enterText(dialogField(), 'Belanja sayur');
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox());
      await startApp(tester);

      expect(find.text('Belanja sayur'), findsOneWidget);
    });
  });

  group('Fitur D: batal hapus', () {
    List<String> shownTitles(WidgetTester tester) => tester
        .widgetList<TaskTile>(find.byType(TaskTile))
        .map((tile) => tile.task.title)
        .toList();

    // Membuat tiga tugas lalu menghapus yang di tengah ("B").
    Future<void> addThreeAndDeleteMiddle(WidgetTester tester) async {
      for (final title in ['C', 'B', 'A']) {
        await typeTask(tester, title);
        await tapAddButton(tester);
      }
      expect(shownTitles(tester), ['A', 'B', 'C']);

      await tester.drag(find.text('B'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(shownTitles(tester), ['A', 'C']);
    }

    testWidgets('Batalkan mengembalikan tugas ke posisi semula', (
      tester,
    ) async {
      await startApp(tester);
      await addThreeAndDeleteMiddle(tester);

      await tester.tap(find.text('Batalkan'));
      await tester.pumpAndSettle();

      expect(shownTitles(tester), ['A', 'B', 'C']);
    });

    testWidgets('Tugas yang dikembalikan tetap ada setelah dibuka ulang', (
      tester,
    ) async {
      await startApp(tester);
      await addThreeAndDeleteMiddle(tester);
      await tester.tap(find.text('Batalkan'));
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox());
      await startApp(tester);

      expect(shownTitles(tester), ['A', 'B', 'C']);
    });

    testWidgets('SnackBar hilang sendiri setelah beberapa detik', (
      tester,
    ) async {
      await startApp(tester);
      await addThreeAndDeleteMiddle(tester);
      expect(find.text('Batalkan'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      expect(find.text('Batalkan'), findsNothing);
      expect(shownTitles(tester), ['A', 'C']);
    });
  });

  group('Fitur E: mode gelap mengikuti sistem', () {
    Brightness appBrightness(WidgetTester tester) =>
        Theme.of(tester.element(find.text('Daftar Tugas'))).brightness;

    testWidgets('Tema terang saat sistem terang', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await startApp(tester);

      expect(appBrightness(tester), Brightness.light);
    });

    testWidgets('Tema gelap saat sistem gelap', (tester) async {
      // Meniru HP yang sedang memakai mode gelap.
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await startApp(tester);

      expect(appBrightness(tester), Brightness.dark);
    });
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
