import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class BuscaCEP extends StatefulWidget {
  @override
  _BuscaCEPState createState() => _BuscaCEPState();
}

class _BuscaCEPState extends State<BuscaCEP> {

   final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _cepController = TextEditingController();

  String resultado;

  _buscaCEP()  async {

    String cep = _cepController.text;

    String url = "https://viacep.com.br/ws/${cep}/json/";

    http.Response response;

    response = await http.get(url);

    Map<String, dynamic> retorno = json.decode(response.body);

    String apiLogradouro = retorno["logradouro"];
    String apiBairro = retorno["bairro"];
    String apiCidade = retorno["localidade"];
    String apiUf = retorno["uf"];
    String apiCEP = retorno["cep"];


    setState(() {
      resultado = apiLogradouro + ', ' + apiBairro + ' - ' + apiCidade + ', ' + apiUf + ' --> ' + apiCEP;
      print(apiLogradouro);
    });
  }

  @override
  void initState() {
    super.initState();
    //zera o valor das variaveis
    resultado = null;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Busca CEP'),
        centerTitle: true,
        backgroundColor: Colors.limeAccent[700],
      ),
      body: SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              controller: _cepController,
              decoration: InputDecoration(
                labelText: 'Digite um CEP',
                labelStyle: TextStyle(
                  color: Colors.limeAccent[700]
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FlatButton(
                onPressed: () {
                  if(_cepController.text.isEmpty){
                    _onFail('Ajuda ai né carinha, digita algo antes de consultar...');
                    setState(() {
                      resultado = null;
                    });
                  }
                  _buscaCEP();
                },
                child: Container(
                  width: double.infinity,
                  height: 30,
                  color: Colors.limeAccent[700],
                  child: Center(
                    child: Text('Consultar ', style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,),
                  )
                ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
              child: Text('Resultado: ${resultado ?? 'Faça uma consulta'}', style: TextStyle(
                fontSize: 16
              ),),
            ),
          ],
        ),
      ),
      )
    );
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
