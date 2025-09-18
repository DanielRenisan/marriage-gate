class TokenResult {
  final String token;
  final int tokenType;
  final bool isError;
  final String? error;

  TokenResult({
    required this.token,
    required this.tokenType,
    required this.isError,
    this.error,
  });

  factory TokenResult.fromJson(Map<String, dynamic> json) {
    return TokenResult(
      token: json['token'] ?? '',
      tokenType: json['tokenType'] ?? 0,
      isError: json['IsError'] ?? false,
      error: json['Error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'tokenType': tokenType,
      'IsError': isError,
      'Error': error,
    };
  }
}
