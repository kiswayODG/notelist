import 'package:flutter/material.dart';
import 'package:notelist/constants/routes.dart';
import 'package:notelist/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

import '../services/auth/auth_exceptions.dart';
import '../utilities/dialog_erreur.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isLoading = false; // Variable pour indiquer le chargement

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    final email = _email.text;
    final password = _password.text;

    // Début du chargement
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.firebase().logIn(email: email, password: password);
      final user = AuthService.firebase().currentUser;

      if (user?.isEmailVerified ?? false) {
        Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (_) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(emailVerifyRoute, (_) => false);
      }
    } on WrongPasswordAuthException {
      await showErrorDialog(context, "Mot de passe incorrect");
    } on UserNotFoundAuthException {
      await showErrorDialog(context, "Utilisateur non existant");
    } on GenericAuthException {
      await showErrorDialog(context, 'Erreur de connexion');
    } finally {
      // Fin du chargement
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Entrez votre email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Entrez votre mot de passe'),
          ),
          // Affichage du bouton ou du spinner en fonction de l'état de chargement
          _isLoading
              ? const CircularProgressIndicator() // Spinner pendant le chargement
              : TextButton(
            onPressed: () async {
              await _logIn();
            },
            child: const Text("Se connecter"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute, (route) => false);
            },
            child: const Text("Créer  votre compte"),
          ),
        ],
      ),
    );
  }
}
