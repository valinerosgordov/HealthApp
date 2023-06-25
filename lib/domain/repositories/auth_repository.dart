import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


class AuthRepository {


  Future logOut() async {
    await FirebaseAuth.instance.signOut();
    await FirebaseAuth.instance.signOut();

  }
}