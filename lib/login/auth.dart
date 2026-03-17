import 'package:firebase_auth/firebase_auth.dart';
import 'package:ircell/backend/shared_pref.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  Stream<User?> get userChanges => _firebaseAuth.userChanges();
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid != null) {
        await LocalStorage.saveUID(uid);
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await LocalStorage.saveUID(uid);
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await LocalStorage.clearUID();
      await EventCache.clearCache();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
}
