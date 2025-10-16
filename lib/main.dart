import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/note_repository.dart';
import 'data/providers/note_mock_provider.dart'; // Mock provider - no backend needed!
import 'bloc/note/note_bloc.dart';
import 'presentation/screens/note_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      // Using mock provider - works without backend!
      create: (context) => NoteRepository(dataProvider: NoteMockProvider()),
      child: BlocProvider(
        create: (context) => NoteBloc(
          repository: context.read<NoteRepository>(),
        ),
        child: MaterialApp(
          title: 'Note Taking App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const NoteListScreen(),
        ),
      ),
    );
  }
}
