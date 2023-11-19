import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:http/http.dart';

void main() {
  runApp(const OpenerBtnScreen());
}

class OpenerBtnScreen extends StatefulWidget {
  const OpenerBtnScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OpenerBtnScreenState createState() => _OpenerBtnScreenState();
}

class _OpenerBtnScreenState extends State<OpenerBtnScreen> {
  ButtonState openingState = ButtonState.idle;
  // void snackbar(BuildContext context, String data) {
  //   final snackBar = SnackBar(
  //     content: Text(data),
  //     duration: const Duration(seconds: 3),
  //     action: SnackBarAction(
  //       label: 'Хүсэлтийг цуцлахуу',
  //       onPressed: () {
  //         setState(() {

  //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         });
  //       },
  //     ),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  Future openDoor(
    String uriAdress,
  ) async {
    setState(() {
      openingState = ButtonState.loading;
    });
    try {
      Response response = await post(Uri.parse(uriAdress));
      // Response response = Response('', 200);
      if (response.statusCode == 200) {
        setState(() {
          openingState = ButtonState.success;
        });
      } else {
        setState(() {
          openingState = ButtonState.fail;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        openingState = ButtonState.fail;
      });
    }

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        openingState = ButtonState.idle;
      });
    });
  }

  void onPressedIconWithText() {
    switch (openingState) {
      case ButtonState.idle:
        openingState = ButtonState.loading;

        openDoor("http://192.168.1.25/open");
        break;
      case ButtonState.loading:
        openingState = ButtonState.idle;
        break;
      case ButtonState.success:
        openingState = ButtonState.idle;
        break;
      case ButtonState.fail:
        openingState = ButtonState.idle;
        break;
    }
    setState(
      () {
        openingState = openingState;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: ProgressButton.icon(
              minWidth: 300,
              height: 500,
              iconedButtons: {
                ButtonState.idle: IconedButton(
                    text: 'Send',
                    icon: const Icon(Icons.send, color: Colors.white),
                    color: Colors.deepPurple.shade500),
                ButtonState.loading: IconedButton(
                    text: 'Loading', color: Colors.deepPurple.shade700),
                ButtonState.fail: IconedButton(
                    text: 'Failed',
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    color: Colors.red.shade300),
                ButtonState.success: IconedButton(
                    text: 'Success',
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    color: Colors.green.shade400)
              },
              onPressed: onPressedIconWithText,
              state: openingState),
        ),
      ),
    );
  }
}
