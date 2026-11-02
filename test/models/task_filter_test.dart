import 'package:flutter_test/flutter_test.dart';

import 'package:todolist_c/models/task.dart';
import 'package:todolist_c/models/task_filter.dart';

// Unit test murni: hanya menguji logika, tanpa menggambar widget apa pun,
// sehingga sangat cepat dan mudah dibaca.
void main() {
  final createdAt = DateTime(2026, 11, 1);
  final activeTask = Task(id: '1', title: 'Belum', createdAt: createdAt);
  final doneTask = Task(
    id: '2',
    title: 'Sudah',
    isDone: true,
    createdAt: createdAt,
  );

  test('all menerima semua tugas', () {
    expect(TaskFilter.all.matches(activeTask), isTrue);
    expect(TaskFilter.all.matches(doneTask), isTrue);
  });

  test('active hanya menerima tugas yang belum selesai', () {
    expect(TaskFilter.active.matches(activeTask), isTrue);
    expect(TaskFilter.active.matches(doneTask), isFalse);
  });

  test('done hanya menerima tugas yang sudah selesai', () {
    expect(TaskFilter.done.matches(activeTask), isFalse);
    expect(TaskFilter.done.matches(doneTask), isTrue);
  });
}
