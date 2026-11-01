import 'package:flutter_test/flutter_test.dart';

import 'package:todolist_c/models/task.dart';

void main() {
  final createdAt = DateTime(2026, 11, 1, 8, 30);
  final task = Task(id: '1', title: 'Belajar Flutter', createdAt: createdAt);

  test('isDone bawaannya false', () {
    expect(task.isDone, isFalse);
  });

  test('copyWith mengubah field yang diberikan saja', () {
    final done = task.copyWith(isDone: true);

    expect(done.isDone, isTrue);
    expect(done.id, '1');
    expect(done.title, 'Belajar Flutter');
    expect(done.createdAt, createdAt);
  });

  test('copyWith tanpa argumen menghasilkan nilai yang sama', () {
    final copy = task.copyWith();

    expect(copy.id, task.id);
    expect(copy.title, task.title);
    expect(copy.isDone, task.isDone);
    expect(copy.createdAt, task.createdAt);
  });

  test('copyWith bisa mengganti beberapa field sekaligus', () {
    final changed = task.copyWith(title: 'Belajar Dart', isDone: true);

    expect(changed.title, 'Belajar Dart');
    expect(changed.isDone, isTrue);
    expect(changed.id, '1');
  });

  test('toJson lalu fromJson menghasilkan data yang sama', () {
    final original = task.copyWith(isDone: true);

    final restored = Task.fromJson(original.toJson());

    expect(restored.id, original.id);
    expect(restored.title, original.title);
    expect(restored.isDone, original.isDone);
    expect(restored.createdAt, original.createdAt);
  });

  test('toJson menyimpan createdAt sebagai teks ISO 8601', () {
    expect(task.toJson()['createdAt'], '2026-11-01T08:30:00.000');
  });
}
