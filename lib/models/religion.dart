class Religion {
  final String id;
  final String name;
  final bool isActive;

  Religion({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory Religion.fromJson(Map<String, dynamic> json) {
    return Religion(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
    };
  }
}

class ReligionResponse {
  final List<Religion> data;
  final int totalCount;
  final int pageNumber;
  final int pageSize;

  ReligionResponse({
    required this.data,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  factory ReligionResponse.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List?)
        ?.map((item) => Religion.fromJson(item))
        .toList() ?? [];

    return ReligionResponse(
      data: dataList,
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }
}
