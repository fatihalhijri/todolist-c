import 'package:flutter/material.dart';

/// Dialog untuk mengubah judul tugas.
///
/// Dialog ini "mengembalikan" judul baru lewat `Navigator.pop(context, judul)`.
/// Pemanggil menerimanya dari `await showDialog<String>(...)`; nilainya null
/// jika pengguna menekan "Batal" atau menutup dialog.
class EditTaskDialog extends StatefulWidget {
  const EditTaskDialog({super.key, required this.initialTitle});

  final String initialTitle;

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  // Diisi judul lama supaya pengguna cukup memperbaikinya.
  late final _controller = TextEditingController(text: widget.initialTitle);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _title => _controller.text.trim();

  void _save() {
    if (_title.isEmpty) return;
    Navigator.pop(context, _title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah tugas'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Judul tugas'),
        textInputAction: TextInputAction.done,
        // Bangun ulang setiap kali teks berubah agar tombol Simpan ikut
        // aktif/nonaktif.
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          // pop tanpa nilai: hasil showDialog menjadi null (dibatalkan).
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          // onPressed null membuat tombol tampil nonaktif.
          onPressed: _title.isEmpty ? null : _save,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
