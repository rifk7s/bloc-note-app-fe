import 'package:equatable/equatable.dart';
import '../../models/note.dart';

/// Base class for all Note events
abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class NoteStarted extends NoteEvent {
  const NoteStarted();
}

class NoteAdded extends NoteEvent {
  final Note note;

  const NoteAdded({required this.note});

  @override
  List<Object?> get props => [note];
}

class NoteUpdated extends NoteEvent {
  final int id;
  final Note note;

  const NoteUpdated({
    required this.id,
    required this.note,
  });

  @override
  List<Object?> get props => [id, note];
}

class NoteDeleted extends NoteEvent {
  final int id;

  const NoteDeleted({required this.id});

  @override
  List<Object?> get props => [id];
}

class NoteSelected extends NoteEvent {
  final Note note;

  const NoteSelected({required this.note});

  @override
  List<Object?> get props => [note];
}

class NoteDeselected extends NoteEvent {
  final Note note;

  const NoteDeselected({required this.note});

  @override
  List<Object?> get props => [note];
}

class NoteSelectionModeToggled extends NoteEvent {
  const NoteSelectionModeToggled();
}

class AllNotesSelected extends NoteEvent {
  const AllNotesSelected();
}

class AllNotesDeselected extends NoteEvent {
  const AllNotesDeselected();
}

class SelectedNotesDeleted extends NoteEvent {
  const SelectedNotesDeleted();
}
