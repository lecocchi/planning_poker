import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planning_poker/data_user.dart';
import 'package:planning_poker/infraestructure/firestore_repository.dart';
import 'package:planning_poker/infraestructure/user_utils.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var total = MediaQuery.of(context).size.height - 56.0;

    return Scaffold(
      // drawer: const Drawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 179, 203, 180),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Bienvenido ${DataUser().name}',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 30,
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: total * 0.15,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Title(),
            ),
          ),
          SizedBox(
            height: total * 0.7,
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Body(),
              ),
            ),
          ),
          SizedBox(
            height: total * 0.15,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Puntaje(),
            ),
          )
        ],
      ),
      floatingActionButton: isUserAdmin(DataUser().email!)
          ? StreamBuilder(
              stream: FirebaseFirestore.instance.collection('show').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (snapshot.data!.docs.first.get('isVisible'))
                        FloatingActionButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('show')
                                .doc('visible')
                                .set({'isVisible': false});
                          },
                          backgroundColor: Colors.redAccent,
                          child: const Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      else
                        FloatingActionButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('show')
                                .doc('visible')
                                .set({'isVisible': true});
                          },
                          backgroundColor: Colors.lightBlue,
                          child: const Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          TextEditingController controller =
                              TextEditingController();
                          // set up the button
                          Widget createButton = ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.blue),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                              minimumSize: WidgetStateProperty.all(
                                const Size(150, 50),
                              ),
                            ),
                            onPressed: () async {
                              FirebaseFirestore.instance
                                  .collection('histories')
                                  .doc('QxvC82eRqvLNaFdhkYq4')
                                  .set({
                                'isActive': true,
                                'title': controller.text
                              });

                              FirebaseFirestore.instance
                                  .collection('show')
                                  .doc('visible')
                                  .set({'isVisible': true});

                              var collection = FirebaseFirestore.instance
                                  .collection('users-vote');
                              var snapshots = await collection.get();

                              for (var doc in snapshots.docs) {
                                await doc.reference.delete();
                              }

                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Crear',
                              style: TextStyle(fontSize: 16),
                            ),
                          );

                          Widget cancelButton = ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(255, 223, 133, 108)),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                              minimumSize: WidgetStateProperty.all(
                                const Size(150, 50),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(fontSize: 16),
                            ),
                          );

                          showGeneralDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierLabel: MaterialLocalizations.of(context)
                                  .modalBarrierDismissLabel,
                              barrierColor: Colors.black45,
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder: (BuildContext buildContext,
                                  Animation animation,
                                  Animation secondaryAnimation) {
                                return AlertDialog(
                                  shape: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  title: const Text(
                                    'Crear una historia',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  content: Container(
                                    margin: const EdgeInsets.only(
                                        top: 30, right: 15, left: 15),
                                    width: 500,
                                    height: 100,
                                    child: TextField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(strokeAlign: 5)),
                                          labelText: 'Título de la historia',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          hintText:
                                              'Ingrese el título de la historia'),
                                    ),
                                  ),
                                  actions: [cancelButton, createButton],
                                );
                              });
                        },
                        backgroundColor: Colors.lightGreen,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              },
            )
          : Container(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users-vote').snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<CardCustomer> list = snapshot.data!.docs
            .map((u) => CardCustomer(
                  email: u.id,
                  name: u.get('name'),
                  value: u.get('voto'),
                  url: u.get('urlAvatar'),
                ))
            .toList();

        return Wrap(
          children: list,
        );
      },
    );
  }
}

class AppBarCustomer extends StatelessWidget {
  const AppBarCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 65,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 179, 203, 180),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Bienvenido ${DataUser().name}',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 30, left: 40, right: 40),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('histories')
            .where('isActive', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String text = snapshot.data!.docs.first.get('title');
            return Text(
              text,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlue,
              ),
            );
          }
        },
      ),
    );
  }
}

class CardCustomer extends StatelessWidget {
  const CardCustomer(
      {super.key,
      this.name = '',
      this.email = '',
      this.value = '',
      this.url = 'https://images.unsplash.com/photo-1597466765990-64ad1c35dafc',
      this.color = const Color.fromARGB(255, 159, 205, 242)});

  final String name;
  final Color? color;
  final String value;
  final String email;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 5,
      margin: const EdgeInsets.all(20),
      child: Container(
        width: 170,
        height: 190,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ImageNetwork(
              url: url,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Spacer(),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('show').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  bool isVisible = snapshot.data!.docs.first.get('isVisible');

                  return (email == DataUser().email) || isVisible
                      ? Text(
                          value,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 138, 96, 139)),
                        )
                      : const Icon(
                          Icons.question_mark,
                          size: 35,
                          color: Color.fromARGB(255, 90, 67, 97),
                        );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class ImageNetwork extends StatelessWidget {
  const ImageNetwork({
    super.key,
    this.url = '',
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: _getImageFromUrl(url),
    );
  }

  ImageProvider _getImageFromUrl(String url) {
    return Image.network(
      url,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/images/user.png'),
    ).image;
  }
}

class Puntaje extends StatelessWidget {
  const Puntaje({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> numbers = ["0.5", "1", "2", "3", "5", "8"];

    return Center(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('show').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            bool isVisible = snapshot.data!.docs.first.get('isVisible');

            if (isVisible) {
              return const Average();
            } else {
              return Wrap(
                children: numbers
                    .map((n) => Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 25),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(255, 179, 203, 180)),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(255, 0, 0, 0)),
                              minimumSize: WidgetStateProperty.all(
                                const Size(100, 75),
                              ),
                            ),
                            child: Text(
                              n,
                              style: const TextStyle(fontSize: 30),
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users-vote')
                                  .doc(DataUser().email)
                                  .set({
                                'name': DataUser().name,
                                'voto': n,
                                'urlAvatar': DataUser().avatar,
                              });
                            },
                          ),
                        ))
                    .toList(),
              );
            }
          }),
    );
  }
}

class Average extends StatelessWidget {
  const Average({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users-vote').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double total = 0;
          double average = 0;
          for (var u in snapshot.data!.docs) {
            total = total + double.parse(u.get('voto'));
            average = total / snapshot.data!.docs.length;
          }

          return Container(
            padding: const EdgeInsets.only(bottom: 50),
            child: Text(
              'El promedio es: ${average.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          );
        }

        return Container();
      },
    );
  }
}
