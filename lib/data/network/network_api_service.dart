import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:trivia_quiz_app/data/network/app_exceptions.dart';
import 'package:trivia_quiz_app/data/network/base_api_service.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future<dynamic> getApi(String url) async {
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      log(response.statusCode.toString());
      return _processResponse(response);
    } on SocketException {
      throw InternetException("No Internet Connection");
    } on RequestTimeoutException {
      throw RequestTimeoutException("Request Timed Out");
    } catch (e) {
      throw ServerException("Unexpected Error: $e");
    }
  }

  @override
  Future<dynamic> postApi(String url, Map<String, dynamic> data) async {
    try {
      final response =
          await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      }).timeout(Duration(seconds: 10));
      log(response.statusCode.toString());
      _processResponse(response);
    } on SocketException {
      throw InternetException("No Internet Connection");
    } on RequestTimeoutException {
      throw RequestTimeoutException("Request Timed Out");
    } catch (e) {
      throw ServerException("Unexpected Error: $e");
    }
  }

  /// Handles and processes API responses based on HTTP status codes.
  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body); // Return parsed JSON response
      case 400:
        throw BadRequestException("Bad Request");
      case 401:
      case 403:
        throw UnauthorizedException("Unauthorized Access");
      case 404:
        throw NotFoundException("Resource Not Found");
      case 500:
      default:
        throw ServerException("Server Error: ${response.statusCode}");
    }
  }
}
