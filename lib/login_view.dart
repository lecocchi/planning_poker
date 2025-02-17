import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planning_poker/data_user.dart';
import 'package:planning_poker/infraestructure/user_utils.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 650,
          height: 280,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 20,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GradientText(
                'Welcome to Planning Poker',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 231, 88, 83),
                  Color.fromARGB(255, 19, 77, 163),
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  side: WidgetStateProperty.all<BorderSide>(
                      BorderSide(color: Colors.grey[200]!)),
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 255, 255, 255)),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  maximumSize: WidgetStateProperty.all(
                    const Size(300, 60),
                  ),
                  minimumSize: WidgetStateProperty.all(
                    const Size(300, 60),
                  ),
                ),
                onPressed: () async {
                  // ignore: use_build_context_synchronously
                  // Navigator.of(context).pushNamed('/home');

                  UserCredential? userCredential = await signInWithGoogle();

                  User? user = userCredential.user;

                  if (user != null) {
                    if (user.email!.contains("@latam.com")) {
                      DataUser().email = user.email!;
                      DataUser().name = user.displayName!.split(' ')[0];
                      DataUser().avatar = user.photoURL!;
                      DataUser().isLogin = true;

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamed('/home');
                    } else {
                      // set up the button
                      Widget okButton = TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      );

                      // set up the AlertDialog
                      AlertDialog alert = AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          "Email Inválido",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Row(
                          children: [
                            Text(
                              "Debe ser un email del tipo ",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "xxx@latam.com",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          ],
                        ),
                        actions: [
                          okButton,
                        ],
                      );

                      // show the dialog
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/google.png'),
                      height: 40,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Sign In with Google',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Version 0.0.4",
                style: TextStyle(color: Colors.grey[400]!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
