import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:planning_poker/data_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> emailAdmin = [
  'leandrococchi.acidlabs@latam.com'.toLowerCase(),
  'laurarobles.acidlabs@latam.com'.toLowerCase(),
  'christian.espinoza@latam.com'.toLowerCase(),
  'joseilys.vasquez@latam.com'.toLowerCase(),
  'lecocchi@gmail.com'.toLowerCase()
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

Future<User?> signInWithGoogle() async {
  // Initialize Firebase
  await Firebase.initializeApp();
  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;
  // The `GoogleAuthProvider` can only be
  // used while running on the web
  GoogleAuthProvider authProvider = GoogleAuthProvider();

  try {
    final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);
    user = userCredential.user;
  } catch (e) {
    return null;
  }

  return user;
}
