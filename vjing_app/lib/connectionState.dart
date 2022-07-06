import 'package:mobx/mobx.dart';

class ConnectionState {
  static final ConnectionState _instance = ConnectionState._internal();

  Observable isConnected = Observable(false);
  Observable login = Observable('');
  Observable token = Observable('');

  Action connect;
  Action disconnect;

  factory ConnectionState() {
    return _instance;
  }

  ConnectionState._internal() {
    connect = Action((String newLogin, String newToken) {
      isConnected.value = true;
      login.value = newLogin;
      token.value = newToken;
    });

    disconnect = Action(() {
      isConnected.value = false;
      token.value = '';
    });
  }
}
