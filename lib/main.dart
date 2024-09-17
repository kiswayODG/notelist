import 'package:flutter/material.dart';
import 'package:notelist/views/home_page_view.dart';
import 'package:notelist/views/login_view.dart';
import 'package:notelist/views/notes/notes_views.dart';
import 'package:notelist/views/register_view.dart';
import 'package:notelist/views/verify_email_view.dart';

import 'constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePageView(),
    routes: {
      loginRoute:(context)=>const LoginView(),
      registerRoute : (context) => const RegisterView(),
      notesRoute : (context) => const NoteViews(),
      emailVerifyRoute : (context) => VerifyEmailView(),
    },
  ));
}



