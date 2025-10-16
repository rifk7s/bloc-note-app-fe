import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'features/notes/data/repositories/note_repository.dart';
import 'features/notes/data/providers/note_mock_provider.dart';
import 'features/notes/presentation/bloc/note_bloc.dart';
import 'features/notes/presentation/pages/note_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      // Currently using mock provider - works without backend!
      // More at lib/features/notes/data/providers
      create: (context) => NoteRepository(dataProvider: NoteMockProvider()),
      child: BlocProvider(
        create: (context) => NoteBloc(
          repository: context.read<NoteRepository>(),
        ),
        child: MaterialApp(
          title: AppStrings.appTitle,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const NoteListPage(),
        ),
      ),
    );
  }
}
