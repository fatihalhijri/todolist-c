import 'package:flutter/material.dart';

import '../models/task_filter.dart';

/// Tombol pilihan filter: Semua, Belum, Selesai.
class FilterBar extends StatelessWidget {
  const FilterBar({super.key, required this.selected, required this.onChanged});

  final TaskFilter selected;
  final ValueChanged<TaskFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      // SegmentedButton bisa memilih lebih dari satu, jadi nilainya berupa
      // Set. Di sini hanya satu yang boleh dipilih (bawaan multiSelectionEnabled
      // = false), maka kita kirim {selected} dan ambil .first.
      child: SegmentedButton<TaskFilter>(
        segments: const [
          ButtonSegment(value: TaskFilter.all, label: Text('Semua')),
          ButtonSegment(value: TaskFilter.active, label: Text('Belum')),
          ButtonSegment(value: TaskFilter.done, label: Text('Selesai')),
        ],
        selected: {selected},
        onSelectionChanged: (values) => onChanged(values.first),
        // Tanpa ikon centang supaya ketiga tombol tetap muat di layar kecil.
        showSelectedIcon: false,
      ),
    );
  }
}
