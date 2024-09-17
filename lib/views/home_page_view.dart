
import 'package:flutter/material.dart';
import 'package:notelist/services/auth/auth_service.dart';
import 'package:notelist/views/login_view.dart';
import 'package:notelist/views/verify_email_view.dart';
import 'notes/notes_views.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.done:
             final user = (AuthService.firebase().currentUser);

             if (user!= null){
                if(user.isEmailVerified){
                  return  NoteViews();
                } else{
                  return const VerifyEmailView();
                }
             }else {
               return const LoginView();
             }

            default:
              return const CircularProgressIndicator();
          }

        },);
  }
}
