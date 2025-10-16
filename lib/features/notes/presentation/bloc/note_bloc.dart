import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/note_repository.dart';
import '../../../../core/models/failure.dart';
import '../../../../core/constants/app_constants.dart';
import 'note_event.dart';
import 'note_state.dart';

/// Note BLoC - Business Logic Component
/// Handles all business logic for notes
/// Receives events from UI, calls repository, emits states
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _repository;

  NoteBloc({required NoteRepository repository})
      : _repository = repository,
        super(const NoteState()) {
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
    emit(state.copyWith(status: NoteStatus.loading));
    try {
      final notes = await _repository.getNotes();
      emit(state.copyWith(
        status: NoteStatus.loaded,
        notes: notes,
      ));
    } on Failure catch (e) {
      emit(state.copyWith(
        status: NoteStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NoteStatus.error,
        errorMessage: AppStrings.genericError,
      ));
    }
  }

  Future<void> _onNoteAdded(
    NoteAdded event,
    Emitter<NoteState> emit,
  ) async {
    emit(state.copyWith(status: NoteStatus.loading));
    try {
      await _repository.createNote(event.note);
      emit(state.copyWith(
        status: NoteStatus.success,
        successMessage: AppStrings.noteAddedSuccess,
      ));
      // Reload notes after adding
      add(NoteStarted());
    } on Failure catch (e) {
      emit(state.copyWith(
        status: NoteStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NoteStatus.error,
        errorMessage: 'Failed to add note',
      ));
    }
  }

  Future<void> _onNoteUpdated(
    NoteUpdated event,
    Emitter<NoteState> emit,
  ) async {
    emit(state.copyWith(status: NoteStatus.loading));
    try {
      await _repository.updateNote(event.id, event.note);
      emit(state.copyWith(
        status: NoteStatus.success,
        successMessage: AppStrings.noteUpdatedSuccess,
      ));
      // Reload notes after updating
      add(NoteStarted());
    } on Failure catch (e) {
      emit(state.copyWith(
        status: NoteStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NoteStatus.error,
        errorMessage: 'Failed to update note',
      ));
    }
  }

  Future<void> _onNoteDeleted(
    NoteDeleted event,
    Emitter<NoteState> emit,
  ) async {
    emit(state.copyWith(status: NoteStatus.loading));
    try {
      await _repository.deleteNote(event.id);
      emit(state.copyWith(
        status: NoteStatus.success,
        successMessage: AppStrings.noteDeletedSuccess,
      ));
      // Reload notes after deleting
      add(NoteStarted());
    } on Failure catch (e) {
      emit(state.copyWith(
        status: NoteStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NoteStatus.error,
        errorMessage: 'Failed to delete note',
      ));
    }
  }

  Future<void> _onNoteSelected(
    NoteSelected event,
    Emitter<NoteState> emit,
  ) async {
    final selectedNotes = List.of(state.selectedNotes);
    if (!selectedNotes.contains(event.note)) {
      selectedNotes.add(event.note);
    }
    emit(state.copyWith(
      selectedNotes: selectedNotes,
      isSelectionMode: true,
    ));
  }

  Future<void> _onNoteDeselected(
    NoteDeselected event,
    Emitter<NoteState> emit,
  ) async {
    final selectedNotes = List.of(state.selectedNotes);
    selectedNotes.remove(event.note);

    final isSelectionMode = selectedNotes.isNotEmpty;

    emit(state.copyWith(
      selectedNotes: selectedNotes,
      isSelectionMode: isSelectionMode,
    ));
  }

  Future<void> _onNoteSelectionModeToggled(
    NoteSelectionModeToggled event,
    Emitter<NoteState> emit,
  ) async {
    final newSelectionMode = !state.isSelectionMode;
    emit(state.copyWith(
      isSelectionMode: newSelectionMode,
      selectedNotes: newSelectionMode ? [] : state.selectedNotes,
    ));
  }

  Future<void> _onAllNotesSelected(
    AllNotesSelected event,
    Emitter<NoteState> emit,
  ) async {
    emit(state.copyWith(
      selectedNotes: List.of(state.notes),
      isSelectionMode: true,
    ));
  }

  Future<void> _onAllNotesDeselected(
    AllNotesDeselected event,
    Emitter<NoteState> emit,
  ) async {
    emit(state.copyWith(
      selectedNotes: [],
      isSelectionMode: false,
    ));
  }

  Future<void> _onSelectedNotesDeleted(
    SelectedNotesDeleted event,
    Emitter<NoteState> emit,
  ) async {
    if (state.selectedNotes.isEmpty) return;

    emit(state.copyWith(status: NoteStatus.loading));
    try {
      final noteIds = state.selectedNotes
          .where((note) => note.id != null)
          .map((note) => note.id!)
          .toList();

      await _repository.deleteMultipleNotes(noteIds);

      emit(state.copyWith(
        status: NoteStatus.success,
        successMessage: AppStrings.notesDeletedSuccess,
      ));
      // Reload notes after deleting
      add(NoteStarted());
    } on Failure catch (e) {
      emit(state.copyWith(
        status: NoteStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NoteStatus.error,
        errorMessage: 'Failed to delete notes',
      ));
    }
  }
}
