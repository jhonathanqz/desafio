import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class BuscaLartLng extends StatefulWidget {

  @override
  _BuscaLartLngState createState() => _BuscaLartLngState();
}

class _BuscaLartLngState extends State<BuscaLartLng> {

  var latDevice;
  var lngDevice;

  String end1;
  String end2;
  double latD;
  double lngD;

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
    getAddressUser();
  }

  getAddressUser() async {
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
        title: Text('Busca Lat/Lng'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[600],
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
                  if(end2.isEmpty){
                    _getCurrentLocation();
                  }
                  else if(end2.isNotEmpty){
                    setState(() {
                    end1 = '';
                    end2 = '';
                  });
                  }
                  
                },
                child: Container(
                    width: double.infinity,
                    height: 40,
                    color: Colors.deepOrange[600],
                    child: Center(
                      child: Text(
                        'Consultar Endereço da minha localização',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),

              SizedBox(
                height: 30,
              ),

              Container(
                child: Text(end2 ?? '', style: TextStyle(
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
