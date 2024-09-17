import 'package:flutter/material.dart';
import 'package:notelist/constants/routes.dart';
import 'package:notelist/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verification d'email"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Text(" Un mail de vérification a été envoyeé, veuilllez consulter votre  mail"),
          Text("Vous n'avez pas reçu de mail ? "),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text("Re-envoyez un mail de verification")
          ),
          TextButton(
              onPressed: () async {
                AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (_)=> false);
              },
              child: const Text("Quitter")
          )
        ],
      ),
    );

  }
}
