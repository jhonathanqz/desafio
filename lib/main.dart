import 'dart:convert';

import 'package:desafio/cep.dart';
import 'package:desafio/lat_lng.dart';
import 'package:desafio/matheus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

/************************************************************/

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var connected;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List data;
  Future<String> getJSONData() async {
    final String url = "viacep.com.br/ws/15910000/json/";

    var response = await http.get(url);

    Map<String, dynamic> retorno = json.decode(response.body);

    data = json.decode(response.body);
    print(retorno);

    return "Dados obtidos com sucesso";
  }

   @override
  void initState() {
    super.initState();
    //solicitar permissões ao usuário
    grantPermissions();
    //verifica conexão com a internet
    _checkInternetConnection();

  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Desafio Borgatto"),
        centerTitle: true,
        backgroundColor: Colors.cyan[700],
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            color: Colors.cyan[700],
            onPressed: () {
              if(connected == '1'){
                Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => BuscaCEP()));
              }
              else if(connected == '2'){
                _onFail('Por favor, verifique sua conexão com a internet antes de prosseguir');
              }
            },
            child: Container(
              width: double.infinity,
              child: Text(
              'Busca CEP',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            )
          ),
          FlatButton(
            color: Colors.cyan[700],
            onPressed: () {
              if(connected == '1'){
                Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => BuscaLartLng()));
              }
              else if(connected == '2'){
                _onFail('Por favor, verifique sua conexão com a internet antes de prosseguir');
              }
            },
            child: Container(
              width: double.infinity,
              child: Text(
              'Busca Lat/Lng',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            )
          ),
          FlatButton(
            color: Colors.cyan[700],
            onPressed: () {
              if(connected == '1'){
                Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Matheus()));
              }
              else if(connected == '2'){
                _onFail('Por favor, verifique sua conexão com a internet antes de prosseguir');
              }
            },
            child: Container(
              width: double.infinity,
              child: Text(
              'Accesys',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            )
          ),
        ],
      )),
    );
  }

  Future<void> grantPermissions() async {
    if (await Permission.location.isUndetermined ||
        await Permission.location.isDenied) {
      await Permission.location.request();
    }
    if (await Permission.locationWhenInUse.isUndetermined ||
        await Permission.locationWhenInUse.isDenied) {
      await Permission.locationWhenInUse.request();
    }
  }

   _checkInternetConnection() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      connected='2';
    }else if (result == ConnectivityResult.mobile){
      connected='1';
    }else if(result == ConnectivityResult.wifi){
      connected='1';
    }
  }

  void _onFail(String title) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

 
}
