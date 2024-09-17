
import 'package:firebase_core/firebase_core.dart';
import 'package:notelist/services/auth/auth_user.dart';
import 'package:notelist/services/auth/auth_exceptions.dart';
import 'package:notelist/services/auth/auth_provider.dart';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;

import '../../firebase_options.dart';


class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser?> createUser({required String email, required String password}) async {
    // TODO: implement createUser

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    final user = currentUser;
    if(user != null){
      return user;
    } else {
      throw UserNotLoggedInAuthException();
    }
    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password'){
        throw WeakPasswordAuthException();
      }
       // await showErrorDialog(context,"Mot de passe très court, 6 caractères au moins!");
      else if(e.code=="email-already-in-use"){
        throw EmailAlreadyInUseAuthException();
      //  await showErrorDialog(context, "utilisateur avec le meme email existant");
      }
      else if(e.code == 'invalid-email'){
        throw InvalidEmailAuthException();
      //  await showErrorDialog(context, "Email non valide");
      }else if (e.code == 'network-request-failed') {
        throw BadConnexionAuthException();
      //  await showErrorDialog(context, "Vérifier votre connexion internet");
      }
      else {
        throw GenericAuthException();
      //  await showErrorDialog(context, 'Erreur:${e.code}');
      }
    } catch(_) {
      throw GenericAuthException();
    }
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if(user !=null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser?> logIn({required String email, required String password}) async{
    // TODO: implement logIn
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if(user != null){
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch(e){
      if (e.code == 'invalid-credential')
        //await showErrorDialog(context,"Mot de passe invalide");
        throw WrongPasswordAuthException();
      else if(e.code == 'user-not-found'){
        //await showErrorDialog(context, "Utilisateur non existant");
        throw UserNotFoundAuthException();
      }
      else if(e.code == 'wrong-password'){
        //await showErrorDialog(context, "Mot de passe incorrect");
        throw WrongPasswordAuthException();
      }
      else if(e.code == 'invalid-email'){
        //await showErrorDialog(context, "Email non valide");
        throw InvalidEmailAuthException();
      }else if (e.code == 'too-many-requests') {
        throw TooManyRequestAuthException();
        //await showErrorDialog(context, "Trop de tentative, reessayez plutard");
      }
      else {
        //await showErrorDialog(context, 'Erreur:${e.code}');
        throw GenericAuthException();
      }
    } catch(_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async{
    // TODO: implement logOut
  final user = FirebaseAuth.instance.currentUser;
  if(user != null) {
    await FirebaseAuth.instance.signOut();
  } else {
    throw UserNotLoggedInAuthException();
  }
  }

  @override
  Future<void> sendEmailVerification() async{
    // TODO: implement sendEmailVerification
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      await user.sendEmailVerification();
    }else {
      throw UserNotLoggedInAuthException();
    }


  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }


}