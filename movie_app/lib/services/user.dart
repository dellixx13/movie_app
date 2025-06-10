import 'dart:convert';

import 'package:movie_app/models/user_login.dart';
import 'package:movie_app/models/response_data_map.dart';
import 'package:movie_app/models/user_login.dart';
import 'package:movie_app/services/url.dart' as url;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future registerUser(data) async {
    var uri = Uri.parse(url.BaseUrl + "/register_admin");
    var register = await http.post(uri, body: data);

    if (register.statusCode == 200) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
            status: true, message: "Sukses menambah user", data: data);
        return response;
      } else {
        var message = '';
        for (String key in data['message'].keys) {
          message += data['message'][key][0].toString() + '\n';
        }
        ResponseDataMap response =
            ResponseDataMap(status: false, message: message);
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message:
              'gagal menambah user dengan code error${register.statusCode}');
      return response;
    }
  }

  Future loginUser(data) async {
    var uri = Uri.parse(url.BaseUrl + "/auth/login");
    var register = await http.post(uri, body: data);

    if (register.statusCode == 200) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        UserLogin userLogin = UserLogin(
            status: data["status"],
            token: data["token"],
            message: data["message"],
            id: data["user"]["id"],
            nama_user: data["user"]["nama_user"],
            email: data["user"]["email"],
            role: data["user"]["role"]);
        await userLogin.prefs();
        ResponseDataMap response = ResponseDataMap(
            status: true, message: "Sukses login user", data: data);
        return response;
      } else {
        ResponseDataMap response =
            ResponseDataMap(status: false, message: 'Email dan password salah');
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message:
              "gagal menambah user dengan code error ${register.statusCode}");
      return response;
    }
  }

  Future getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserLogin userLogin = UserLogin(
        status: prefs.getBool("status")!,
        token: prefs.getString("token")!,
        message: prefs.getString("message")!,
        id: prefs.getInt("id")!,
        nama_user: prefs.getString("nama_user")!,
        email: prefs.getString("email")!,
        role: prefs.getString("role")!);
    return userLogin;
  }
}
