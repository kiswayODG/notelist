import 'package:flutter/material.dart';
import 'package:notelist/constants/routes.dart';
import 'package:notelist/services/auth/auth_service.dart';
import '../services/auth/auth_exceptions.dart';
import '../utilities/dialog_erreur.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nouvel utilisateur"),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body:  Column(
                  children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                      const InputDecoration(hintText: 'Entrez votre email'),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          hintText: 'Entrez votre mot de passe'),
                    ),
                    TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                             await AuthService.firebase()
                                .createUser(
                                email: email, password: password);

                             AuthService.firebase().sendEmailVerification();
                            Navigator.of(context).pushNamed(emailVerifyRoute);
                          }on WeakPasswordAuthException {
                            await showErrorDialog(context, 'Mot de passe court');
                          } on EmailAlreadyInUseAuthException {
                            await showErrorDialog(context, 'Email existant déjà!');
                          } on InvalidEmailAuthException {
                            await showErrorDialog(context, 'Cet email est invalide!');
                          }
                          on GenericAuthException {
                            await showErrorDialog(context, 'Erreur lors de la création !');
                          }

                        },
                        child: const Text("Enregistrer")),
                    TextButton(onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,
                              (route) => false);
                    }, child: const Text("Connectez-vous à votre compte"))
                  ],
        ));
  }
}