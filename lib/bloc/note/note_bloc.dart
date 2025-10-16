import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/note_repository.dart';
import 'note_event.dart';
import 'note_state.dart';

/// Note BLoC - Business Logic Component
/// Handles all business logic for notes
/// Receives events from UI, calls repository, emits states
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _repository;

  NoteBloc({required NoteRepository repository})
      : _repository = repository,
        super(const NoteInitial()) {
    // Register event handlers
    on<NoteStarted>(_onNoteStarted);
    on<NoteAdded>(_onNoteAdded);
    on<NoteUpdated>(_onNoteUpdated);
    on<NoteDeleted>(_onNoteDeleted);
    on<NoteSelected>(_onNoteSelected);
    on<NoteDeselected>(_onNoteDeselected);
    on<NoteSelectionModeToggled>(_onNoteSelectionModeToggled);
    on<AllNotesSelected>(_onAllNotesSelected);
    on<AllNotesDeselected>(_onAllNotesDeselected);
    on<SelectedNotesDeleted>(_onSelectedNotesDeleted);
  }

  /// Event handler: Load notes from repository
  Future<void> _onNoteStarted(
    NoteStarted event,
    Emitter<NoteState> emit,
  ) async {
    emit(const NoteLoading());
    try {
      final notes = await _repository.getNotes();
      emit(NoteLoaded(notes: notes));
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }

  Future<void> _onNoteAdded(
    NoteAdded event,
    Emitter<NoteState> emit,
  ) async {
    emit(const NoteOperationInProgress(message: 'Adding note...'));
    try {
      await _repository.createNote(event.note);
      emit(const NoteOperationSuccess(message: 'Note added successfully'));
      // Reload notes after adding
      add(const NoteStarted());
    } catch (e) {
      emit(NoteError(message: 'Failed to add note: ${e.toString()}'));
    }
  }

  Future<void> _onNoteUpdated(
    NoteUpdated event,
    Emitter<NoteState> emit,
  ) async {
    emit(const NoteOperationInProgress(message: 'Updating note...'));
    try {
      await _repository.updateNote(event.id, event.note);
      emit(const NoteOperationSuccess(message: 'Note updated successfully'));
      // Reload notes after updating
      add(const NoteStarted());
    } catch (e) {
      emit(NoteError(message: 'Failed to update note: ${e.toString()}'));
    }
  }

  Future<void> _onNoteDeleted(
    NoteDeleted event,
    Emitter<NoteState> emit,
  ) async {
    emit(const NoteOperationInProgress(message: 'Deleting note...'));
    try {
      await _repository.deleteNote(event.id);
      emit(const NoteOperationSuccess(message: 'Note deleted successfully'));
      // Reload notes after deleting
      add(const NoteStarted());
    } catch (e) {
      emit(NoteError(message: 'Failed to delete note: ${e.toString()}'));
    }
  }

  Future<void> _onNoteSelected(
    NoteSelected event,
    Emitter<NoteState> emit,
  ) async {
    final currentState = state;
    if (currentState is NoteLoaded) {
      final selectedNotes = List.of(currentState.selectedNotes);
      if (!selectedNotes.contains(event.note)) {
        selectedNotes.add(event.note);
      }
      emit(currentState.copyWith(selectedNotes: selectedNotes));
    }
  }

  Future<void> _onNoteDeselected(
    NoteDeselected event,
    Emitter<NoteState> emit,
  ) async {
    final currentState = state;
    if (currentState is NoteLoaded) {
      final selectedNotes = List.of(currentState.selectedNotes);
      selectedNotes.remove(event.note);

      final isSelectionMode = selectedNotes.isNotEmpty;

      emit(currentState.copyWith(
        selectedNotes: selectedNotes,
        isSelectionMode: isSelectionMode,
      ));
    }
  }

  Future<void> _onNoteSelectionModeToggled(
    NoteSelectionModeToggled event,
    Emitter<NoteState> emit,
  ) async {
    final currentState = state;
    if (currentState is NoteLoaded) {
      final newSelectionMode = !currentState.isSelectionMode;
      emit(currentState.copyWith(
        isSelectionMode: newSelectionMode,
        selectedNotes: newSelectionMode ? [] : currentState.selectedNotes,
      ));
    }
  }

  Future<void> _onAllNotesSelected(
    AllNotesSelected event,
    Emitter<NoteState> emit,
  ) async {
    final currentState = state;
    if (currentState is NoteLoaded) {
      emit(currentState.copyWith(
        selectedNotes: List.of(currentState.notes),
        isSelectionMode: true,
      ));
    }
  }

  Future<void> _onAllNotesDeselected(
    AllNotesDeselected event,
    Emitter<NoteState> emit,
  ) async {
    final currentState = state;
    if (currentState is NoteLoaded) {
      emit(currentState.copyWith(
        selectedNotes: [],
        isSelectionMode: false,
      ));
    }
  }

  Future<void> _onSelectedNotesDeleted(
    SelectedNotesDeleted event,
    Emitter<NoteState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NoteLoaded || currentState.selectedNotes.isEmpty) {
      return;
    }

    emit(const NoteOperationInProgress(message: 'Deleting selected notes...'));
    try {
      final noteIds = currentState.selectedNotes
          .where((note) => note.id != null)
          .map((note) => note.id!)
          .toList();

      await _repository.deleteMultipleNotes(noteIds);

      emit(const NoteOperationSuccess(message: 'Notes deleted successfully'));
      // Reload notes after deleting
      add(const NoteStarted());
    } catch (e) {
      emit(NoteError(message: 'Failed to delete notes: ${e.toString()}'));
    }
  }
}
