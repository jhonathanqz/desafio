import 'package:http/http.dart' as http;

class APIDesafio {

  
  static Future<bool> send(String lat, String lng) async {
    var url = 'utl_api';

    Map params = {
      'latitude': lat,
      'longitude': lng,
    };

    var response = await http.post(url, body: params);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    

    return true;
  }
}