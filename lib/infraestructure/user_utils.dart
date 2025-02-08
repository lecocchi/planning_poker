import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planning_poker/data_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> emailAdmin = [
  'leandrococchi.acidlabs@latam.com'.toLowerCase(),
  'laurarobles.acidlabs@latam.com'.toLowerCase(),
  'christian.espinoza@latam.com'.toLowerCase(),
  'joseilys.vasquez@latam.com'.toLowerCase(),
  'lecocchi@gmail.com'.toLowerCase(),
  'MariaJose.Ruiz@latam.com'.toLowerCase(),
  'gonzalo.roco@latam.com'.toLowerCase()
];

bool isUserAdmin(String email) {
  return emailAdmin.contains(email.toLowerCase());
}

Future<void> login(String email) {
  return FirebaseFirestore.instance
      .collection('user')
      .where('email', isEqualTo: email)
      .get()
      .then((QuerySnapshot snapshot) {
    for (var doc in snapshot.docs) {
      if (doc.get('email') == email) {
        DataUser().email = email;
        DataUser().name = doc.get('name');
        DataUser().isLogin = true;
      }
    }
  }).catchError((error) {
    DataUser().isLogin = false;
  });
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
