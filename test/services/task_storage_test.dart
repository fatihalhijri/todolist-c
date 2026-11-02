import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:todolist_c/models/task.dart';
import 'package:todolist_c/services/task_storage.dart';

void main() {
  // Mengganti penyimpanan asli HP dengan penyimpanan tiruan di memori,
  // supaya tes bisa jalan di komputer dan selalu mulai dari kondisi bersih.
  void useStoredData(Map<String, Object> data) {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(data);
  }

  setUp(() => useStoredData({}));

  test('memuat saat belum ada data menghasilkan daftar kosong', () async {
    final tasks = await TaskStorage().loadTasks();

    expect(tasks, isEmpty);
  });

  test('menyimpan lalu memuat menghasilkan daftar yang sama', () async {
    final storage = TaskStorage();
    final tasks = [
      Task(id: '2', title: 'Belanja', createdAt: DateTime(2026, 11, 1, 9)),
      Task(
        id: '1',
        title: 'Belajar Flutter',
        isDone: true,
        createdAt: DateTime(2026, 11, 1, 8),
      ),
    ];

    await storage.saveTasks(tasks);
    final loaded = await storage.loadTasks();

    expect(loaded.length, 2);
    for (var i = 0; i < tasks.length; i++) {
      expect(loaded[i].id, tasks[i].id);
      expect(loaded[i].title, tasks[i].title);
      expect(loaded[i].isDone, tasks[i].isDone);
      expect(loaded[i].createdAt, tasks[i].createdAt);
    }
  });

  test('menyimpan lagi menimpa data lama', () async {
    final storage = TaskStorage();
    final createdAt = DateTime(2026, 11, 1);

    await storage.saveTasks([
      Task(id: '1', title: 'Lama', createdAt: createdAt),
      Task(id: '2', title: 'Lama juga', createdAt: createdAt),
    ]);
    await storage.saveTasks([
      Task(id: '3', title: 'Baru', createdAt: createdAt),
    ]);
    final loaded = await storage.loadTasks();

    expect(loaded.map((task) => task.title), ['Baru']);
  });

  group('memuat data rusak menghasilkan daftar kosong', () {
    const brokenData = {
      'bukan JSON': 'ini bukan json',
      'JSON bukan daftar': '{"id": "1"}',
      'isi daftar bukan objek': '[1, 2, 3]',
      'field hilang': '[{"id": "1"}]',
      'tipe field salah':
          '[{"id": 1, "title": "A", "isDone": false, '
          '"createdAt": "2026-11-01T08:00:00.000"}]',
      'tanggal tidak valid':
          '[{"id": "1", "title": "A", "isDone": false, '
          '"createdAt": "bukan tanggal"}]',
    };

    brokenData.forEach((name, text) {
      test(name, () async {
        useStoredData({'tasks_v1': text});

        final tasks = await TaskStorage().loadTasks();

        expect(tasks, isEmpty);
      });
    });
  });
}
