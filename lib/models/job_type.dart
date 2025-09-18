class JobType {
  final String id;
  final String name;
  final bool isActive;

  JobType({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory JobType.fromJson(Map<String, dynamic> json) {
    return JobType(
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

class JobTypeResponse {
  final List<JobType> data;
  final int totalCount;
  final int pageNumber;
  final int pageSize;

  JobTypeResponse({
    required this.data,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  factory JobTypeResponse.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List?)
        ?.map((item) => JobType.fromJson(item))
        .toList() ?? [];

    return JobTypeResponse(
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
