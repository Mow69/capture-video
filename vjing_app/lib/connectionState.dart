import 'package:mobx/mobx.dart';

class ConnectionState {
  Observable isConnected = Observable(false);
  Observable login = Observable('');
  Observable token = Observable('');

  Action connect;
  Action disconnect;

  ConnectionState(){
    connect = Action((String newLogin, String newToken){
      isConnected.value = true;
      login.value = newLogin;
      token.value = newToken;
    });

    disconnect = Action((){
      isConnected.value = false;
      token.value = '';
    });
  }
}