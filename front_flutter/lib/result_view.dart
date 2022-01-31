import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  List<dynamic> players;
  ResultView({required this.players, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // players.sort((a, b) => a['score'].compareTo(b['score']));
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Text(
                "Score final",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 100),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      var player = players[index];
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            player['pseudo'],
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          Text(
                            player['score'].toString(),
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          )
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                    itemCount: players.length),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  //Navigator.of(context).push();
                },
                child: const SizedBox(
                  height: 50,
                  width: 100,
                  child: Center(
                    child: Text(
                      "Fermer",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
