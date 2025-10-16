import '../../models/note.dart';

/// Base class for all Note events
abstract class NoteEvent {}

class NoteStarted extends NoteEvent {}

class NoteAdded extends NoteEvent {
  final Note note;
  NoteAdded({required this.note});
}

class NoteUpdated extends NoteEvent {
  final int id;
  final Note note;
  NoteUpdated({required this.id, required this.note});
}

class NoteDeleted extends NoteEvent {
  final int id;
  NoteDeleted({required this.id});
}

class NoteSelected extends NoteEvent {
  final Note note;
  NoteSelected({required this.note});
}

class NoteDeselected extends NoteEvent {
  final Note note;
  NoteDeselected({required this.note});
}

class NoteSelectionModeToggled extends NoteEvent {}

class AllNotesSelected extends NoteEvent {}

class AllNotesDeselected extends NoteEvent {}

class SelectedNotesDeleted extends NoteEvent {}
