class Error {
  final String title;
  final String detail;
  final int statusCode;

  Error({
    required this.title,
    required this.detail,
    required this.statusCode,
  });

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      title: json['Title'] ?? 'Unknown error',
      detail: json['Detail'] ?? 'Unknown details',
      statusCode: json['StatusCode'] ?? 400,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Detail': detail,
      'StatusCode': statusCode,
    };
  }
}
