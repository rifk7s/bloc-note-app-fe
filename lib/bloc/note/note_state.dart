import 'package:equatable/equatable.dart';
import '../../models/note.dart';

/// Base class for all Note states
abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {
  const NoteInitial();
}

class NoteLoading extends NoteState {
  const NoteLoading();
}

class NoteLoaded extends NoteState {
  final List<Note> notes;
  final List<Note> selectedNotes;
  final bool isSelectionMode;

  const NoteLoaded({
    required this.notes,
    this.selectedNotes = const [],
    this.isSelectionMode = false,
  });

  @override
  List<Object?> get props => [notes, selectedNotes, isSelectionMode];

  NoteLoaded copyWith({
    List<Note>? notes,
    List<Note>? selectedNotes,
    bool? isSelectionMode,
  }) {
    return NoteLoaded(
      notes: notes ?? this.notes,
      selectedNotes: selectedNotes ?? this.selectedNotes,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
    );
  }

  @override
  String toString() {
    return 'NoteLoaded(notes: ${notes.length}, selected: ${selectedNotes.length}, selectionMode: $isSelectionMode)';
  }
}

class NoteError extends NoteState {
  final String message;

  const NoteError({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'NoteError(message: $message)';
}

/// Operation in progress state - adding, updating, or deleting
class NoteOperationInProgress extends NoteState {
  final String? message;

  const NoteOperationInProgress({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'NoteOperationInProgress(message: $message)';
}

class NoteOperationSuccess extends NoteState {
  final String? message;

  const NoteOperationSuccess({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'NoteOperationSuccess(message: $message)';
}
