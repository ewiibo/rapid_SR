import 'package:flutter/material.dart';
import 'package:front/widget/input_field.dart';

class ConnexionView extends StatelessWidget {
  ConnexionView({Key? key}) : super(key: key);

  //final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();
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
                onPressed: () {},
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
}
