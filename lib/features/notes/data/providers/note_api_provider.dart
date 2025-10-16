import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/note.dart';
import '../../../../core/constants/app_constants.dart';

/// Data Provider for Note API
/// Handles all HTTP communication with the backend
/// This is the lowest level - just raw API calls, no business logic
abstract class NoteDataProvider {
  Future<List<Note>> getNotes();
  Future<Note> createNote(Note note);
  Future<Note> updateNote(int id, Note note);
  Future<void> deleteNote(int id);
}

class NoteApiProvider implements NoteDataProvider {
  final String baseUrl;
  final http.Client httpClient;

  NoteApiProvider({
    String? baseUrl,
    http.Client? httpClient,
  })  : baseUrl = baseUrl ?? AppConstants.apiBaseUrl,
        httpClient = httpClient ?? http.Client();

  @override
  Future<List<Note>> getNotes() async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/notes'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body) as List;
        return jsonList
            .map((json) => Note.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw NoteApiException(
          'Failed to load notes',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is NoteApiException) rethrow;
      throw NoteApiException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Note> createNote(Note note) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/notes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(note.toJson()),
      );

      if (response.statusCode == 201) {
        return Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw NoteApiException(
          'Failed to create note',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is NoteApiException) rethrow;
      throw NoteApiException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<Note> updateNote(int id, Note note) async {
    try {
      final response = await httpClient.patch(
        Uri.parse('$baseUrl/notes/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(note.toJson()),
      );

      if (response.statusCode == 200) {
        return Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw NoteApiException(
          'Failed to update note',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is NoteApiException) rethrow;
      throw NoteApiException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl/notes/$id'),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw NoteApiException(
          'Failed to delete note',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is NoteApiException) rethrow;
      throw NoteApiException('Network error: ${e.toString()}');
    }
  }

  /// Dispose HTTP client
  void dispose() {
    httpClient.close();
  }
}

/// Custom exception for API errors
class NoteApiException implements Exception {
  final String message;
  final int? statusCode;

  NoteApiException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'NoteApiException: $message (Status: $statusCode)';
    }
    return 'NoteApiException: $message';
  }
}
