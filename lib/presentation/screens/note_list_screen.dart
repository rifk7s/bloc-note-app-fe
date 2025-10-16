import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/note/note_bloc.dart';
import '../../bloc/note/note_event.dart';
import '../../bloc/note/note_state.dart';
import 'note_detail_screen.dart';
import 'add_note_screen.dart';

/// Uses BLoC for state management - NO setState, NO HTTP calls
class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is NoteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is NoteOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Operation successful'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Note List'),
            actions: _buildAppBarActions(context, state),
          ),
          body: _buildBody(context, state),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNoteScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, NoteState state) {
    if (state is! NoteLoaded) return [];

    if (!state.isSelectionMode) {
      // Normal mode - show select all button
      return [
        IconButton(
          icon: const Icon(Icons.select_all),
          onPressed: () {
            context.read<NoteBloc>().add(const AllNotesSelected());
          },
        ),
      ];
    } else {
      // Selection mode - show delete button
      return [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: state.selectedNotes.isEmpty
              ? null
              : () {
                  _showDeleteConfirmation(context);
                },
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.read<NoteBloc>().add(const AllNotesDeselected());
          },
        ),
      ];
    }
  }

  /// Build body based on state
  Widget _buildBody(BuildContext context, NoteState state) {
    if (state is NoteInitial) {
      // Initial state - load notes
      context.read<NoteBloc>().add(const NoteStarted());
      return const Center(child: CircularProgressIndicator());
    }

    if (state is NoteLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is NoteOperationInProgress) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(state.message ?? 'Processing...'),
          ],
        ),
      );
    }

    if (state is NoteError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<NoteBloc>().add(const NoteStarted());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is NoteLoaded) {
      if (state.notes.isEmpty) {
        return const Center(
          child: Text('No notes yet. Add one!'),
        );
      }

      return ListView.builder(
        itemCount: state.notes.length,
        itemBuilder: (context, index) {
          final note = state.notes[index];
          final isSelected = state.selectedNotes.contains(note);

          return ListTile(
            leading: state.isSelectionMode
                ? Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      if (value == true) {
                        context.read<NoteBloc>().add(NoteSelected(note: note));
                      } else {
                        context
                            .read<NoteBloc>()
                            .add(NoteDeselected(note: note));
                      }
                    },
                  )
                : null,
            title: Text(note.title),
            subtitle: Text(
              note.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              if (state.isSelectionMode) {
                // Toggle selection
                if (isSelected) {
                  context.read<NoteBloc>().add(NoteDeselected(note: note));
                } else {
                  context.read<NoteBloc>().add(NoteSelected(note: note));
                }
              } else {
                // Navigate to detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailScreen(note: note),
                  ),
                );
              }
            },
            onLongPress: () {
              // Enter selection mode and select this note
              if (!state.isSelectionMode) {
                context.read<NoteBloc>().add(NoteSelected(note: note));
              }
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    final bloc = context.read<NoteBloc>();
    final state = bloc.state;
    if (state is! NoteLoaded) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Notes'),
        content: Text(
          'Are you sure you want to delete ${state.selectedNotes.length} note(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              bloc.add(const SelectedNotesDeleted());
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
