//Exception de connexion

class UserNotFoundAuthException implements Exception {

}

class WrongPasswordAuthException implements Exception {

}

class TooManyRequestAuthException implements Exception {

}

//Exceptoin de création de compte

class WeakPasswordAuthException implements Exception {

}

class EmailAlreadyInUseAuthException implements Exception {

}


class InvalidEmailAuthException implements Exception {

}

class BadConnexionAuthException implements Exception {

}

//Exception génériques -- non connues


class GenericAuthException implements Exception {

}


class UserNotLoggedInAuthException implements Exception {

}