import 'package:flutter/material.dart';
import 'package:front/boardview.dart';
import 'package:front/widget/input_field.dart';
import 'gamecommunication.dart';

class ConnexionView extends StatefulWidget {
  ConnexionView({Key? key}) : super(key: key);

  @override
  State<ConnexionView> createState() => _ConnexionViewState();
}

class _ConnexionViewState extends State<ConnexionView> {
  //final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();
  int myId = 0;

  @override
  void initState() {
    super.initState();
    game.addListener((message) {
      switch (message["messageType"]) {
        case "connected":
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return BoardView(myId: myId, myName: _pseudoController.text, players: message["players"]);
          }));
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Projet Systeme reparti",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 150,
              ),
              // CustumTextInput(
              //   controller: _addressController,
              //   label: "Adresse du server",
              // ),
              CustumTextInput(
                controller: _pseudoController,
                label: "Nom du joueur",
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: _onConnect,
                child: const SizedBox(
                  height: 50,
                  width: 250,
                  child: Center(
                    child: Text(
                      "Se connecter",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onConnect() {
    myId = DateTime.now().microsecondsSinceEpoch;
    game.send('connect', 20, 10, myId, _pseudoController.text, "");
  }
}
