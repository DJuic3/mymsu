import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'components/view.dart';

class ApiService {
  static const String baseUrl = 'http://139.177.200.139:90/api';

  int userId = 0;

 Future<Map<String, dynamic>> loginUser(String regnum, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'regnum': regnum,
        'password':code,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Please try again');
    }
  }

  Future<Map<String, dynamic>> getUserRegistrationStatus(user) async {
    final dio = Dio();

    try {
      // Retrieve token from SharedPreferences
      final tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();

      // Make a GET request to the Laravel API endpoint
      final response = await dio.get(
        'http://139.177.200.139:90/api/user-registration-status/$userId', // Replace with your actual API endpoint
        options: Options(
          headers: {
            'tokenmobile': tokenmobile,
          },
        ),
      );

      // Check if the response status is OK (200)
      if (response.statusCode == 200) {
        // Parse the response JSON
        final Map<String, dynamic> data = response.data;
        return data;
      } else {
        // Handle non-OK response
        print('Error: ${response.statusCode}');
        return {'status': 0, 'message': 'Failed to fetch user registration status'};
      }
    } catch (error) {
      // Handle Dio errors
      print('Dio Error: $error');
      return {'status': 0, 'message': 'Failed to fetch user registration status'};
    }
  }


}
