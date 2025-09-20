class SalaryFilter {
  final double? minSalary;
  final double? maxSalary;
  final String? currency;
  final bool? isAnnual;

  SalaryFilter({
    this.minSalary,
    this.maxSalary,
    this.currency,
    this.isAnnual,
  });

  Map<String, dynamic> toJson() {
    return {
      'minSalary': minSalary,
      'maxSalary': maxSalary,
      'currency': currency,
      'isAnnual': isAnnual,
    };
  }

  factory SalaryFilter.fromJson(Map<String, dynamic> json) {
    return SalaryFilter(
      minSalary: json['minSalary']?.toDouble(),
      maxSalary: json['maxSalary']?.toDouble(),
      currency: json['currency'],
      isAnnual: json['isAnnual'],
    );
  }
}
