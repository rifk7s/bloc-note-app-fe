import 'package:flutter/material.dart';
import '../../models/note.dart';
import 'update_note_page.dart';

/// Simple display screen - no BLoC needed here
class NoteDetailPage extends StatelessWidget {
  final Note note;

  const NoteDetailPage({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateNotePage(note: note),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              note.body,
              style: const TextStyle(fontSize: 16.0),
            ),
            if (note.createdAt != null) ...[
              const SizedBox(height: 24.0),
              Text(
                'Created: ${_formatDate(note.createdAt!)}',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
            if (note.updatedAt != null) ...[
              const SizedBox(height: 8.0),
              Text(
                'Updated: ${_formatDate(note.updatedAt!)}',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
