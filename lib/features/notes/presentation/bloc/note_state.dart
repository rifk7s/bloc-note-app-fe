import '../../models/note.dart';

/// Note status enum - represents the state of the note feature
enum NoteStatus { initial, loading, loaded, success, error }

/// Single concrete state class following bloc.dev best practices
/// Uses status enum and nullable properties instead of multiple state classes
class NoteState {
  final NoteStatus status;
  final List<Note> notes;
  final List<Note> selectedNotes;
  final bool isSelectionMode;
  final String? errorMessage;
  final String? successMessage;

  const NoteState({
    this.status = NoteStatus.initial,
    this.notes = const [],
    this.selectedNotes = const [],
    this.isSelectionMode = false,
    this.errorMessage,
    this.successMessage,
  });

  /// Copy with method for immutable state updates
  NoteState copyWith({
    NoteStatus? status,
    List<Note>? notes,
    List<Note>? selectedNotes,
    bool? isSelectionMode,
    String? errorMessage,
    String? successMessage,
  }) {
    return NoteState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      selectedNotes: selectedNotes ?? this.selectedNotes,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  String toString() {
    return 'NoteState(status: $status, notes: ${notes.length}, selected: ${selectedNotes.length}, selectionMode: $isSelectionMode)';
  }
}
