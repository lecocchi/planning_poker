import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planning_poker/data_user.dart';
import 'package:planning_poker/infraestructure/firebase_options.dart';
import 'package:planning_poker/router/router_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // DataUser().email = 'leju1712@gmail.com';
  // DataUser().name = 'Pepe';
  // DataUser().avatar = '';
  // DataUser().isLogin = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'Planning Poker',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: RouteGenerator.generateRouter,
    );
  }
}
