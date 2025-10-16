import '../../models/note.dart';
import '../providers/note_api_provider.dart';

/// Note Repository
/// Wraps the data provider and provides a clean interface for the business logic layer
/// Can combine multiple data sources (API, cache, local DB) in the future
class NoteRepository {
  final NoteDataProvider _dataProvider;

  NoteRepository({
    NoteDataProvider? dataProvider,
  }) : _dataProvider = dataProvider ?? NoteApiProvider();

  Future<List<Note>> getNotes() async {
    try {
      return await _dataProvider.getNotes();
    } catch (e) {
      throw RepositoryException('Failed to fetch notes: ${e.toString()}');
    }
  }

  Future<Note> createNote(Note note) async {
    try {
      return await _dataProvider.createNote(note);
    } catch (e) {
      throw RepositoryException('Failed to create note: ${e.toString()}');
    }
  }

  Future<Note> updateNote(int id, Note note) async {
    try {
      return await _dataProvider.updateNote(id, note);
    } catch (e) {
      throw RepositoryException('Failed to update note: ${e.toString()}');
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _dataProvider.deleteNote(id);
    } catch (e) {
      throw RepositoryException('Failed to delete note: ${e.toString()}');
    }
  }

  Future<void> deleteMultipleNotes(List<int> ids) async {
    try {
      for (final id in ids) {
        await _dataProvider.deleteNote(id);
      }
    } catch (e) {
      throw RepositoryException('Failed to delete notes: ${e.toString()}');
    }
  }
}

class RepositoryException implements Exception {
  final String message;

  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}
