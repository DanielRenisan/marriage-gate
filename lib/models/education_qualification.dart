class EducationQualification {
  final String id;
  final String name;
  final bool isActive;

  EducationQualification({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory EducationQualification.fromJson(Map<String, dynamic> json) {
    return EducationQualification(
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

class EducationQualificationResponse {
  final List<EducationQualification> data;
  final int totalCount;
  final int pageNumber;
  final int pageSize;

  EducationQualificationResponse({
    required this.data,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  factory EducationQualificationResponse.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List?)
        ?.map((item) => EducationQualification.fromJson(item))
        .toList() ?? [];

    return EducationQualificationResponse(
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
