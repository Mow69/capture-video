
import 'package:vjing_app/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Home extends StatefulWidget {
  
  final BluetoothDevice server;
  const Home({this.server});  

  @override
  _Home createState() => new _Home();
}

class _Home extends State<Home> {
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mes Filtres"),
        ),
        body: MainPage(),

        bottomNavigationBar: 
           BottomAppBar(child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Icon( 
                  Icons.menu,
                  size: 50,
                  color: Colors.grey[600],
                  )),
                Expanded(
                  child: Image(
                  image: AssetImage("assets/images/logo_Vijit.png"),
                  height: 50,
                  )),
                

              ],
                ),
           ),)
          
      );
          
        // BottomNavigationBar(
        // items: const <BottomNavigationBarItem>[
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.menu),
        //     label: 'Home',
        //   ),
        //   // Image(image: image,)
        //   // BottomNavigationBarItem(
        //   //   icon: ImageIcon(
        //   //      AssetImage("assets/images/logo_Vijit.png"),
                   
        //   //      ),
        //   //   label: "Browse"
            
        //   // ),
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.videocam_off_outlined),
        //     label: 'School',
        //   ),
        //   ])
        // );
  }

}
