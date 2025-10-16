import '../../../models/note.dart';
import 'note_api_provider.dart';

/// Mock implementation of NoteDataProvider that stores notes in memory
/// Challenges:  Stores Data in Memory
class NoteMockProvider implements NoteDataProvider {
  final List<Note> _notes = [];
  int _nextId = 1;

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<Note>> getNotes() async {
    await _simulateNetworkDelay();

    final sortedNotes = List<Note>.from(_notes)
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return sortedNotes;
  }

  @override
  Future<Note> createNote(Note note) async {
    await _simulateNetworkDelay();

    final now = DateTime.now();
    final newNote = Note(
      id: _nextId++,
      title: note.title,
      body: note.body,
      createdAt: now,
      updatedAt: now,
    );

    _notes.add(newNote);
    return newNote;
  }

  @override
  Future<Note> updateNote(int id, Note note) async {
    await _simulateNetworkDelay();

    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) {
      throw NoteApiException('Note with id $id not found');
    }

    final updatedNote = _notes[index].copyWith(
      title: note.title,
      body: note.body,
      updatedAt: DateTime.now(),
    );

    _notes[index] = updatedNote;
    return updatedNote;
  }

  @override
  Future<void> deleteNote(int id) async {
    await _simulateNetworkDelay();

    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) {
      throw NoteApiException('Note with id $id not found');
    }

    _notes.removeAt(index);
  }

  void clearAllNotes() {
    _notes.clear();
    _nextId = 1;
  }
}
