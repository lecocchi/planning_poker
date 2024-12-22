import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  var _alertShowing = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      FlutterWindowClose.setWebReturnValue('Are you sure?');
      return;
    }

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      if (_alertShowing) return false;
      _alertShowing = true;

      return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: const Text('Do you really want to quit?'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        _alertShowing = false;
                      },
                      child: const Text('Yes')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        _alertShowing = false;
                      },
                      child: const Text('No'))
                ]);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
