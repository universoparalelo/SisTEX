import 'dart:convert';

import 'package:systex/services/api/repositores/userRepository.dart';

import '../../../config.dart';
import 'package:http/http.dart' as http;

class UserHttp implements UserRepository {
  @override
  Future<Map<String, dynamic>> authUser(String email, String password) async {
    String pathFinalUrl = pathUrlBase + 'api/users/login';
    Map<String, dynamic> jsonData = {};

    Map<String, String> data = {
      'email': email,
      'contraseña': password,
    };
    var request = await http.post(Uri.parse(pathFinalUrl),
        headers: {
          //"Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          //'Accept': '*/*'
        },
        body: json.encode(data));

    print('code' + request.statusCode.toString());
    //if (request.statusCode == 200) {
    jsonData = json.decode(request.body);
    //}

    return jsonData;
  }
}
