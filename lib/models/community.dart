class SubCommunity {
  final String id;
  final String name;
  final bool isActive;

  SubCommunity({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory SubCommunity.fromJson(Map<String, dynamic> json) {
    return SubCommunity(
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

class Community {
  final String id;
  final String name;
  final bool isActive;
  final List<SubCommunity> subCommunities;

  Community({
    required this.id,
    required this.name,
    required this.isActive,
    required this.subCommunities,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    final subCommunitiesList = (json['subCommunities'] as List?)?.map((item) => SubCommunity.fromJson(item)).toList() ?? [];

    return Community(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
      subCommunities: subCommunitiesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      'subCommunities': subCommunities.map((item) => item.toJson()).toList(),
    };
  }
}

class CommunityResponse {
  final List<Community> data;
  final int totalCount;
  final int pageNumber;
  final int pageSize;

  CommunityResponse({
    required this.data,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  factory CommunityResponse.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List?)?.map((item) => Community.fromJson(item)).toList() ?? [];

    return CommunityResponse(
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
