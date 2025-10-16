import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/note_state.dart';
import 'note_detail_page.dart';
import 'add_note_page.dart';

/// Uses BLoC for state management - NO setState, NO HTTP calls
class NoteListPage extends StatelessWidget {
  const NoteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state.status == NoteStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.status == NoteStatus.success &&
            state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
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
                  builder: (context) => const AddNotePage(),
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
    if (state.status != NoteStatus.loaded) return [];

    if (!state.isSelectionMode) {
      // Normal mode - show select all button
      return [
        IconButton(
          icon: const Icon(Icons.select_all),
          onPressed: () {
            context.read<NoteBloc>().add(AllNotesSelected());
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
            context.read<NoteBloc>().add(AllNotesDeselected());
          },
        ),
      ];
    }
  }

  /// Build body based on state
  Widget _buildBody(BuildContext context, NoteState state) {
    if (state.status == NoteStatus.initial) {
      // Initial state - load notes
      context.read<NoteBloc>().add(NoteStarted());
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == NoteStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == NoteStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.errorMessage ?? 'An error occurred'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<NoteBloc>().add(NoteStarted());
              },
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }

    if (state.status == NoteStatus.loaded) {
      if (state.notes.isEmpty) {
        return const Center(
          child: Text(AppStrings.noNotesFound),
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
                    builder: (context) => NoteDetailPage(note: note),
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

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.delete),
        content: Text(
          'Are you sure you want to delete ${state.selectedNotes.length} note(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              bloc.add(SelectedNotesDeleted());
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}
