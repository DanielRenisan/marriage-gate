import 'package:matrimony_flutter/models/error.dart';

class ApiResponse<T> {
  final T? result;
  final bool isError;
  final Error? error;

  ApiResponse({
    this.result,
    required this.isError,
    this.error,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJson) {
    return ApiResponse<T>(
      result: json['Result'] != null && fromJson != null
          ? fromJson(json['Result'])
          : null,
      isError: json['IsError'] ?? false,
      error: json['Error'] != null ? Error.fromJson(json['Error']) : null,
    );
  }

  factory ApiResponse.error(String title, String detail, int statusCode) {
    return ApiResponse<T>(
      isError: true,
      error: Error(
        title: title,
        detail: detail,
        statusCode: statusCode,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result,
      'IsError': isError,
      'Error': error?.toJson(),
    };
  }
}
