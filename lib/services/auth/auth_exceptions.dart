/*
 * Registration Auth Exceptions
 */

class EmailAlreadyExistsException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

/*
*  Login Auth Exceptions
 */

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

/*
* Other Auth Exceptions
 */

class UserNotLoggedInAuthException implements Exception {}

class GenericAuthException implements Exception {}
