import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  Future getBitcoinData(String url) async {
    http.Response apiResponse = await http.get(url);

    if (apiResponse.statusCode == 200) {
      return jsonDecode(apiResponse.body);
    }
    else {
      print(apiResponse.statusCode);
    }
  }
}