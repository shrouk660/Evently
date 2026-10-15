import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static bool _initialized = false;

  static Future<UserCredential?> signIn() async {
    final googleSignIn = GoogleSignIn.instance;

    if (!_initialized) {
      await googleSignIn.initialize(
        serverClientId: '156976803041-s2ls1sitr0pvi3anu9n9joql7a8tfpm8.apps.googleusercontent.com',
      );
      _initialized = true;
    }

    try {
      final googleUser = await googleSignIn.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }
}