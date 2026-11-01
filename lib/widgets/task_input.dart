import 'package:flutter/material.dart';

/// Kolom teks dan tombol untuk menambah tugas baru.
///
/// Widget ini tidak menyimpan daftar tugas. Ia hanya mengirim teks ke
/// induknya lewat [onSubmitted]; induknya yang memutuskan apa yang dilakukan.
class TaskInput extends StatefulWidget {
  const TaskInput({super.key, required this.onSubmitted});

  /// `ValueChanged<String>` = fungsi yang menerima satu String.
  final ValueChanged<String> onSubmitted;

  @override
  State<TaskInput> createState() => _TaskInputState();
}

// Butuh StatefulWidget karena controller harus hidup selama widget tampil
// dan dibuang (dispose) saat widget hilang.
class _TaskInputState extends State<TaskInput> {
  // Controller memberi kita akses ke isi TextField: membaca dan mengosongkannya.
  final _controller = TextEditingController();

  @override
  void dispose() {
    // Controller memakai memori; wajib dibuang agar tidak bocor.
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    widget.onSubmitted(title);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        children: [
          // Expanded membuat TextField mengisi sisa lebar di samping tombol.
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Tulis tugas baru...',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              // Dipanggil saat Enter / tombol "selesai" di keyboard ditekan.
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: _submit,
            icon: const Icon(Icons.add),
            tooltip: 'Tambah tugas',
          ),
        ],
      ),
    );
  }
}
