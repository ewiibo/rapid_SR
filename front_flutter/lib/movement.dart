import 'dart:convert';

class GameCommunication {
 Map<String, dynamic> serverMessage = {};
  

  _onMessageReceived(serverMessage) {
    Map<String, dynamic> message = json.decode(serverMessage);

    switch (message["messageType"]) {
      case 'move':
        serverMessage["players"] = message["players"];
        break;

      default:
        break;
    }
  }

}



// {
//   messageType : moved,
//   players : [21, 34],
//   jewels : [21, 34],  
// }