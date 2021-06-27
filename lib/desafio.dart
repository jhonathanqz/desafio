import 'dart:convert';

import 'package:desafio/API.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class Desafio extends StatefulWidget {

  @override
  _DesafioState createState() => _DesafioState();
}

class _DesafioState extends State<Desafio> {

  var erroDesafio;
  var url = 'url_api_aqui';

  void myFunction() {

    Map<String, String> headers = {
      "Content-Type": "application/json"
    };

    Map params = {
      'latitude': '-21.2770563',
      'longitude': '-48.4730583',
    };

    String paramsJson = json.encode(params);

    http.post(url, body:paramsJson, headers: headers)
    .then((response) => print(response.body))
    .catchError((erroDesafio) => print('Retorno do erro: ${erroDesafio}'));

}

  Future<void> sendAPI(String lat, String lng) async{
    print('entrei no send');
    try {
    String apiUrl = "URL_AQUI";
    print('to no try');

    Response response = await http.post(apiUrl, body: {

    "lat": latDevice,
    "lng": lngDevice,
  });
    if(response.statusCode != 200){
      print(json.decode(response.body));
    }
    } catch (e) {
      print(e);
    }
}

  String latDevice;
  String lngDevice;
  double latD;
  double lngD;

  String end1;
  String end2;

  void _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latDevice = "${position.latitude}";
      lngDevice = "${position.longitude}";
      print(latDevice);
      print(lngDevice);
      latD = double.tryParse(latDevice);
      lngD = double.tryParse(lngDevice);

    });

    bool ok = await APIDesafio.send('-21.2770563', '-48.4730583');
    if(ok) {
      print('deu certo o POST');
    }else {
      print('Deu ruim');
    }
    myFunction();
    //getEndereco();
  }

  getEndereco() async {
    final coordinates = Coordinates(latD, lngD);

    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    setState(() {
      end1 = address.first.featureName;
      end2 = address.first.addressLine;
    });
    print('print end1');
    print(end1);
    print('print end2');
    print(end2);
    print(latDevice);
  }

  @override
  void initState() {
    super.initState();
    //zera o valor das variaveis
    end1 = '';
    end2 = '';

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desafio'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              FlatButton(
                onPressed: () {
                  _getCurrentLocation();
                  myFunction();
                  
                },
                child: Container(
                    width: double.infinity,
                    height: 40,
                    color: Colors.purple,
                    child: Center(
                      child: Text(
                        'Consultar API',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),

              SizedBox(
                height: 30,
              ),

              Container(
                child: Text(erroDesafio ?? '', style: TextStyle(
                  fontSize: 18
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
