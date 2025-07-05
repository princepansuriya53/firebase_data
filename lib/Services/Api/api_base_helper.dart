import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Custom GET request method
  static Future<ApiResponse> getRequest({
    dynamic body,
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('{ApiEndpoints.baseUrl}$url');
      headers = headers ?? {};
      headers["Content-Type"] = "application/json";
      // if (idToken.value.isNotEmpty) headers["Authorization"] = "Bearer ${idToken.value}";

      print("This is request url ${'{ApiEndpoints.baseUrl}$url'}");
      print("This is request header $headers");
      print("This is request body $body");

      final request = http.Request('GET', uri);
      request.headers.addAll(headers);
      if (body != null) {
        request.body = json.encode(body);
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Status code : ${response.statusCode}');
      // Handle the response
      return handleResponse(response, url: '{ApiEndpoints.baseUrl}$url');
    } catch (e) {
      // Handle unexpected errors
      return ApiResponse.error(
        title: 'Error',
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  static Future<ApiResponse> postRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    bool isTokenRequired = true,
  }) async {
    try {
      // Parse the URL and set default headers
      final uri = Uri.parse('{ApiEndpoints.baseUrl}$url');
      headers = headers ?? {};
      headers["Content-Type"] = "application/json";
      // if (idToken.value.isNotEmpty && isTokenRequired) headers["Authorization"] = "Bearer ${idToken.value}";

      // Debugging prints
      print("This is request URL : ${'{ApiEndpoints.baseUrl}$url'}");
      print("This is request Headers : $headers");
      print("This is request Body : $body");
      print("This is request Body : ${json.encode(body)}");

      // Create the POST request
      final request = http.Request('POST', uri);
      request.headers.addAll(headers);
      if (body != null) {
        request.body = json.encode(body);
      }

      // Send the request and handle the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Status code: ${response.statusCode}');

      return handleResponse(response, url: '{ApiEndpoints.baseUrl}$url');
    } catch (e) {
      // Handle unexpected errors
      return ApiResponse.error(
        title: 'Error',
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  // Custom PUT request method
  static Future<ApiResponse> putRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      // Parse the URL and set default headers
      final uri = Uri.parse('{ApiEndpoints.baseUrl}$url');
      headers = headers ?? {};
      headers["Content-Type"] = "application/json";
      // if (idToken.value.isNotEmpty) headers["Authorization"] = "Bearer $idToken";

      // Debugging prints
      print("This is request URL: ${'{ApiEndpoints.baseUrl}$url'}");
      print("This is request headers: $headers");
      print("This is request body: $body");

      // Create the PUT request
      final request = http.Request('PUT', uri);
      request.headers.addAll(headers);
      if (body != null) {
        request.body = json.encode(body);
      }

      // Send the request and handle the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Status code: ${response.statusCode}');

      return handleResponse(response, url: '{ApiEndpoints.baseUrl}$url');
    } catch (e) {
      // Handle unexpected errors
      return ApiResponse.error(
        title: 'Error',
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  static Future<ApiResponse> deleteRequest({
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      // Parse the URL and set default headers
      final uri = Uri.parse('{ApiEndpoints.baseUrl}$url');
      headers = headers ?? {};
      headers["Content-Type"] = "application/json";
      // if (idToken.value.isNotEmpty) headers["Authorization"] = "Bearer ${idToken.value}";

      // Debugging prints
      print("This is request URL: {'{ApiEndpoints.baseUrl}$url'}");
      print("This is request headers: $headers");
      print("This is request body: $body");

      // Create the DELETE request
      final request = http.Request('DELETE', uri);
      request.headers.addAll(headers);
      if (body != null) {
        request.body = json.encode(body);
      }

      // Send the request and handle the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Status code: ${response.statusCode}');

      return handleResponse(response, url: '{ApiEndpoints.baseUrl}$url');
    } catch (e) {
      // Handle unexpected errors
      return ApiResponse.error(
        title: 'Error',
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  // Method to handle responses
  static ApiResponse handleResponse(
    http.Response response, {
    required String url,
  }) {
    try {
      final statusCode = response.statusCode;
      dynamic responseBody;
      print('This is response 11 : ${response.body.runtimeType}');
      try {
        responseBody = json.decode(response.body);
      } catch (e) {
        responseBody =
            response.body; // Fallback to raw response.body if decoding fails
      }

      print('This is response 11 : ${response.body.runtimeType}');
      print('This is response 22 : ${responseBody}');
      print('This is response 33 : ${responseBody.runtimeType}');

      if (statusCode >= 200 && statusCode < 300) {
        // Return data if successful
        return ApiResponse.success(data: responseBody);
      } else if (statusCode == 401) {
        // if (isAuthTokenValid.value) {
        //   print('Token Expire message : ${url}');
        //
        //   isAuthTokenValid.value = false;
        //   onLogOut();
        //   Get.snackbar('Session Expire', 'Your session is Expire Please login to start new session');
        // }
        return ApiResponse.error(
          title: 'Session Expire',
          message: 'Your session is Expire Please login to start new session.',
          statusCode: 401,
        );
      } else {
        // Handle error responses
        String message = "";
        print("This is body of Error: ${responseBody['message']}");

        try {
          if (responseBody is Map<String, dynamic>) {
            // If already a Map, use it directly
            message =
                responseBody['message'] ??
                responseBody['detail'] ??
                'Something went wrong.';
          } else {
            // Otherwise, try decoding as JSON
            final Map<String, dynamic> data = jsonDecode(responseBody);
            message =
                data['detail'] ?? data['message'] ?? 'Something went wrong.';
          }
        } catch (e) {
          // If JSON decoding fails, return the default string
          message = 'Something went wrong.';
        }

        return ApiResponse.error(
          title: 'Error',
          message: message,
          statusCode: statusCode,
        );
      }
    } catch (e) {
      // Handle JSON decoding errors or unexpected errors
      return ApiResponse.error(
        title: 'Error',
        message: 'Failed to process the response.',
        statusCode: response.statusCode,
      );
    }
  }
}

class ApiResponse {
  final bool success;
  final dynamic data;
  final String? title;
  final String? message;
  final int? statusCode;

  ApiResponse.success({this.data})
    : success = true,
      title = null,
      message = null,
      statusCode = null;

  ApiResponse.error({
    required this.title,
    required this.message,
    required this.statusCode,
  }) : success = false,
       data = null;
}
