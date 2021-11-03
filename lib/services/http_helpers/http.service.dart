import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:planvisitas_grupohbf/services/storage/secure_storage_helper.service.dart';

class HttpService {
  SecureStorageHelper helper = new SecureStorageHelper();
  Future<http.Response> post(Uri url, {dynamic body, dynamic headers}) async {
    final headersParams = await _getHeaders(headers);
    var response =
        await http.post(url, headers: headersParams, body: json.encode(body));

    return response;
  }

  Future<http.Response> get(Uri url, {dynamic headers}) async {
    final headersParams = await _getHeaders(headers);
    var response = await http.get(url, headers: headersParams);

    return response;
  }

  Future<http.Response> patch(Uri url, {dynamic body, dynamic headers}) async {
    final headersParams = await _getHeaders(headers);
    var response =
        await http.patch(url, headers: headersParams, body: json.encode(body));

    return response;
  }

  Future<http.Response> put(Uri url, {dynamic body, dynamic headers}) async {
    final headersParams = await _getHeaders(headers);
    var response =
        await http.put(url, headers: headersParams, body: json.encode(body));

    return response;
  }

  Future<http.Response> delete(Uri url, {dynamic headers}) async {
    final headersParams = await _getHeaders(headers);
    var response = await http.delete(url, headers: headersParams);

    return response;
  }

  Future<Map<String, String>> _getHeaders(dynamic headers) async {
    if (headers != null) return headers;
    var session = await helper.getSessionInfo();

    Map<String, String> headerParams = {
      "Content-Type": 'application/json',
      "userToken": " ${session.Usuario_Id}"
    };
    return headerParams;
  }
}
