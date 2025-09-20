import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_picker/country_picker.dart';
import '../../models/matching_profiles_request.dart';
import '../../models/salary_filter.dart';

// Default values for filter ranges
const int kDefaultMinAge = 18;
const int kDefaultMaxAge = 60;
const double kDefaultMinHeight = 100; // cm
const double kDefaultMaxHeight = 250; // cm
const double kDefaultMinWeight = 25; // kg
const double kDefaultMaxWeight = 150; // kg

class MatchingProfileFilter extends StatefulWidget {
  final MatchingProfilesRequest initial;
  final ScrollController scrollController;

  const MatchingProfileFilter({
    Key? key,
    required this.initial,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<MatchingProfileFilter> createState() => _MatchingProfileFilterState();
}

class _MatchingProfileFilterState extends State<MatchingProfileFilter> {
  // Age range state
  late int _minAge;
  late int _maxAge;

  // Physical attributes
  late double _minHeight;
  late double _maxHeight;
  late double _minWeight;
  late double _maxWeight;

  // Country selection state
  late List<String> _originCountries;
  late List<String> _livingCountries;

  // Lifestyle preferences
  late List<int> _foodHabits;
  late List<int> _drinkHabits;
  late List<int> _smokeHabits;
  late List<int> _willingToRelocate;

  // Physical preferences
  late List<int> _bodyTypes;
  late List<int> _skinComplexions;

  // Cultural background
  late List<String> _religionIds;
  late List<String> _communityIds;
  late List<int> _marriageStatus;
  late List<String> _knownLanguages;

  // Career and Education
  late List<int> _jobSectors;
  late List<String> _jobTypes;
  late List<String> _educationQualifications;
  String? _selectedCurrency;

  // Astrology
  late List<String> _nakshathiram;
  late List<String> _raasi;
  double? _minSalary;
  double? _maxSalary;
  String? _currency;
  bool? _isAnnual;

  // List of available ages for dropdowns (18 to 60)
  final List<int> _ages = List.generate(43, (i) => i + 18);

  // List of available heights (100 to 250 cm)
  final List<int> _heights = List.generate(151, (i) => i + 100);

  // List of available weights (25 to 150 kg)
  final List<int> _weights = List.generate(126, (i) => i + 25);

  @override
  void initState() {
    super.initState();
    final i = widget.initial;

    // Initialize age range
    _minAge = i.minAge;
    _maxAge = i.maxAge;

    // Initialize height and weight
    _minHeight = i.minHeight.toDouble();
    _maxHeight = i.maxHeight.toDouble();
    _minWeight = i.minWeight;
    _maxWeight = i.maxWeight;

    // Initialize country selections
    _originCountries = List<String>.from(i.originCountries);
    _livingCountries = List<String>.from(i.livingCountries);

    // Initialize lifestyle preferences
    _foodHabits = List<int>.from(i.foodHabits);
    _drinkHabits = List<int>.from(i.drinkHabits);
    _smokeHabits = List<int>.from(i.smokeHabits);
    _willingToRelocate = List<int>.from(i.willingToRelocate);

    // Initialize physical preferences
    _bodyTypes = List<int>.from(i.bodyTypes);
    _skinComplexions = List<int>.from(i.skinComplexions);

    // Initialize cultural background
    _religionIds = [];
    _communityIds = [];
    _marriageStatus = [];
    _knownLanguages = [];

    // Initialize career and education
    _jobTypes = [];
    _educationQualifications = [];
    _selectedCurrency = null;

    // Initialize astrology
    _nakshathiram = [];
    _raasi = [];

    // Initialize job and salary
    _jobSectors = List<int>.from(i.jobSectors);
    _minSalary = i.salaryFilter?.minSalary;
    _maxSalary = i.salaryFilter?.maxSalary;
    _currency = i.salaryFilter?.currency;
    _isAnnual = i.salaryFilter?.isAnnual ?? true;
  }

  void _clear() {
    setState(() {
      _minAge = kDefaultMinAge;
      _maxAge = kDefaultMaxAge;
      _minHeight = kDefaultMinHeight;
      _maxHeight = kDefaultMaxHeight;
      _minWeight = kDefaultMinWeight;
      _maxWeight = kDefaultMaxWeight;
      _originCountries.clear();
      _livingCountries.clear();
      _foodHabits.clear();
      _drinkHabits.clear();
      _smokeHabits.clear();
      _willingToRelocate.clear();
      _bodyTypes.clear();
      _skinComplexions.clear();
      _religionIds.clear();
      _communityIds.clear();
      _marriageStatus.clear();
      _knownLanguages.clear();
      _jobSectors.clear();
      _jobTypes.clear();
      _educationQualifications.clear();
      _selectedCurrency = null;
      _minSalary = null;
      _maxSalary = null;
      _currency = null;
      _isAnnual = true;
      _nakshathiram.clear();
      _raasi.clear();
    });
  }

  void _apply() {
    final request = MatchingProfilesRequest(
      minAge: _minAge,
      maxAge: _maxAge,
      originCountries: _originCountries,
      livingCountries: _livingCountries,
      foodHabits: _foodHabits,
      drinkHabits: _drinkHabits,
      smokeHabits: _smokeHabits,
      bodyTypes: _bodyTypes,
      willingToRelocate: _willingToRelocate,
      skinComplexions: _skinComplexions,
      minHeight: _minHeight,
      maxHeight: _maxHeight,
      minWeight: _minWeight.toDouble(),
      maxWeight: _maxWeight.toDouble(),
      religionIds: _religionIds,
      communityIds: _communityIds,
      marriageStatus: _marriageStatus,
      knownLanguages: _knownLanguages,
      jobSectors: _jobSectors,
      jobTypeIds: _jobTypes,
      educationQualificationIds: _educationQualifications,
      salaryFilter: (_minSalary != null || _maxSalary != null || _currency != null || _isAnnual != null)
          ? SalaryFilter(
              minSalary: _minSalary,
              maxSalary: _maxSalary,
              currency: _currency,
              isAnnual: _isAnnual,
            )
          : null,
      nakshathiram: _nakshathiram,
      raasi: _raasi,
    );

    Navigator.of(context).pop(request);
  }

  Future<void> _addItemDialog(List<String> list, String title) async {
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add $title'),
          content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Type and tap Add')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text('Add')),
          ],
        );
      },
    );
    if (value != null && value.isNotEmpty) {
      setState(() => list.add(value));
    }
  }

  Widget _buildCountryDropdown({
    required String label,
    required List<String> selectedCountries,
    required Function(String) onSelect,
    required Function(String) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8.h),
        // Selected countries as chips
        if (selectedCountries.isNotEmpty) ...[
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: selectedCountries.map((countryName) {
              try {
                final country = Country.parse(countryName);
                return Chip(
                  label: Text("${country.flagEmoji} ${country.name}"),
                  onDeleted: () => onRemove(countryName),
                  backgroundColor: Colors.red[50],
                  deleteIconColor: Colors.red,
                );
              } catch (e) {
                return Chip(
                  label: Text(countryName),
                  onDeleted: () => onRemove(countryName),
                  backgroundColor: Colors.red[50],
                  deleteIconColor: Colors.red,
                );
              }
            }).toList(),
          ),
          SizedBox(height: 8.h),
        ],
        // Country selection button
        InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: false,
              countryListTheme: CountryListThemeData(
                flagSize: 25,
                backgroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16.sp),
                bottomSheetHeight: 500.h,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                inputDecoration: InputDecoration(
                  hintText: 'Search country...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              onSelect: (Country country) {
                if (!selectedCountries.contains(country.name)) {
                  onSelect(country.name);
                }
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.add, size: 20.sp, color: Colors.red),
                SizedBox(width: 8.w),
                Text(
                  'Select Country',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Age Range",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _minAge,
                decoration: InputDecoration(
                  labelText: 'Min Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                items: _ages.map((age) {
                  return DropdownMenuItem<int>(
                    value: age,
                    child: Text('$age years'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _minAge = value;
                      if (_maxAge < value) _maxAge = value;
                    });
                  }
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _maxAge,
                decoration: InputDecoration(
                  labelText: 'Max Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                items: _ages.map((age) {
                  return DropdownMenuItem<int>(
                    value: age,
                    child: Text('$age years'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _maxAge = value;
                      if (_minAge > value) _minAge = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        RangeSlider(
          min: 18,
          max: 60,
          divisions: 42,
          labels: RangeLabels(
            _minAge.toString(),
            _maxAge.toString(),
          ),
          values: RangeValues(_minAge.toDouble(), _maxAge.toDouble()),
          activeColor: Colors.red,
          inactiveColor: Colors.grey[300],
          onChanged: (RangeValues values) {
            setState(() {
              _minAge = values.start.round();
              _maxAge = values.end.round();
            });
          },
        ),
      ],
    );
  }

  Widget _chips(String label, List<String> list, {bool addable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ...list.map((item) => Chip(
                  label: Text(item),
                  onDeleted: () => setState(() => list.remove(item)),
                  backgroundColor: Colors.red[50],
                  deleteIconColor: Colors.red,
                )),
            if (addable)
              ActionChip(
                label: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.sp,
                  ),
                ),
                avatar: Icon(Icons.add, size: 18.sp, color: Colors.red),
                backgroundColor: Colors.red[50],
                onPressed: () => _addItemDialog(list, label),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
          child: Row(
            children: [
              const Icon(Icons.filter_alt, color: Colors.red),
              SizedBox(width: 8.w),
              const Expanded(
                child: Text('Filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              TextButton(onPressed: _clear, child: const Text('Clear')),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: _apply,
                child: const Text('Apply'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Info Section
                Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.red, size: 24.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Basic Info',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _buildAgeRangeSelector(),
                SizedBox(height: 16.h),
                _buildCountryDropdown(
                  label: 'Origin Country',
                  selectedCountries: _originCountries,
                  onSelect: (country) => setState(() => _originCountries.add(country)),
                  onRemove: (country) => setState(() => _originCountries.remove(country)),
                ),
                SizedBox(height: 24.h),
                // Cultural Background Section
                Row(
                  children: [
                    Icon(Icons.diversity_3, color: Colors.red, size: 24.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Cultural Background',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Religion
                Text(
                  'Religion',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Hindu'),
                      value: _religionIds.contains('0198a177-988e-70ca-99ff-6ee34a34435a'),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _religionIds.add('0198a177-988e-70ca-99ff-6ee34a34435a');
                        } else {
                          _religionIds.remove('0198a177-988e-70ca-99ff-6ee34a34435a');
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Muslim'),
                      value: _religionIds.contains('0198a185-b8a3-74cf-bc76-82c1bfe21492'),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _religionIds.add('0198a185-b8a3-74cf-bc76-82c1bfe21492');
                        } else {
                          _religionIds.remove('0198a185-b8a3-74cf-bc76-82c1bfe21492');
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Community
                Text(
                  'Community',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Community 1'),
                      value: _communityIds.contains('0196f179-88b0-7a80-b882-8ff319215fce'),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _communityIds.add('0196f179-88b0-7a80-b882-8ff319215fce');
                        } else {
                          _communityIds.remove('0196f179-88b0-7a80-b882-8ff319215fce');
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Community 2'),
                      value: _communityIds.contains('0196f17a-a829-71a0-a80c-388810330393'),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _communityIds.add('0196f17a-a829-71a0-a80c-388810330393');
                        } else {
                          _communityIds.remove('0196f17a-a829-71a0-a80c-388810330393');
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Marital Status
                Text(
                  'Marital Status',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Single'),
                      value: _marriageStatus.contains(1),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _marriageStatus.add(1);
                        } else {
                          _marriageStatus.remove(1);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Married'),
                      value: _marriageStatus.contains(2),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _marriageStatus.add(2);
                        } else {
                          _marriageStatus.remove(2);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Divorced'),
                      value: _marriageStatus.contains(3),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _marriageStatus.add(3);
                        } else {
                          _marriageStatus.remove(3);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Widowed'),
                      value: _marriageStatus.contains(4),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _marriageStatus.add(4);
                        } else {
                          _marriageStatus.remove(4);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Separated'),
                      value: _marriageStatus.contains(5),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _marriageStatus.add(5);
                        } else {
                          _marriageStatus.remove(5);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Known Languages
                Text(
                  'Known Languages',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (_knownLanguages.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _knownLanguages
                        .map((lang) => Chip(
                              label: Text(lang),
                              onDeleted: () => setState(() => _knownLanguages.remove(lang)),
                              backgroundColor: Colors.red[50],
                              deleteIconColor: Colors.red,
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 8.h),
                ],
                StatefulBuilder(
                  builder: (context, dropdownSetState) {
                    final List<String> allLanguages = [
                      'English',
                      'Hindi',
                      'Tamil',
                      'Telugu',
                      'Malayalam',
                      'Kannada',
                      'Bengali',
                      'Marathi',
                      'Gujarati',
                      'Urdu',
                    ];

                    final availableLanguages = allLanguages.where((lang) => !_knownLanguages.contains(lang)).toList();

                    if (availableLanguages.isEmpty) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          'All languages selected',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    return FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Select Language',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          ),
                          isEmpty: state.value == null || state.value!.isEmpty,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: null,
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('Select a language'),
                              items: availableLanguages.map((String lang) {
                                return DropdownMenuItem<String>(
                                  value: lang,
                                  child: Text(lang),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    _knownLanguages.add(value);
                                  });
                                  dropdownSetState(() {
                                    state.didChange(null);
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 24.h),
                // Lifestyle Section
                Row(
                  children: [
                    Icon(Icons.local_activity_outlined, color: Colors.red, size: 24.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Lifestyle',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Food Habits
                Text(
                  'Food Habits',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Vegetarian'),
                      value: _foodHabits.contains(1),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _foodHabits.add(1);
                        } else {
                          _foodHabits.remove(1);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Non-Vegetarian'),
                      value: _foodHabits.contains(2),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _foodHabits.add(2);
                        } else {
                          _foodHabits.remove(2);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Vegan'),
                      value: _foodHabits.contains(3),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _foodHabits.add(3);
                        } else {
                          _foodHabits.remove(3);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Drink Habits
                Text(
                  'Drink Habits',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text("Don't Drink"),
                      value: _drinkHabits.contains(1),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _drinkHabits.add(1);
                        } else {
                          _drinkHabits.remove(1);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Drinks Occasionally'),
                      value: _drinkHabits.contains(2),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _drinkHabits.add(2);
                        } else {
                          _drinkHabits.remove(2);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Drinks Regularly'),
                      value: _drinkHabits.contains(3),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _drinkHabits.add(3);
                        } else {
                          _drinkHabits.remove(3);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Smoke Habits
                Text(
                  'Smoke Habits',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text("Don't Smoke"),
                      value: _smokeHabits.contains(1),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _smokeHabits.add(1);
                        } else {
                          _smokeHabits.remove(1);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Occasionally'),
                      value: _smokeHabits.contains(2),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _smokeHabits.add(2);
                        } else {
                          _smokeHabits.remove(2);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Regularly'),
                      value: _smokeHabits.contains(3),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _smokeHabits.add(3);
                        } else {
                          _smokeHabits.remove(3);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Willing to Relocate
                Text(
                  'Willing to Relocate',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Yes'),
                      value: _willingToRelocate.contains(1),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _willingToRelocate.add(1);
                        } else {
                          _willingToRelocate.remove(1);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('No'),
                      value: _willingToRelocate.contains(2),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _willingToRelocate.add(2);
                        } else {
                          _willingToRelocate.remove(2);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Maybe'),
                      value: _willingToRelocate.contains(3),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _willingToRelocate.add(3);
                        } else {
                          _willingToRelocate.remove(3);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Physical Attributes Section
                Row(
                  children: [
                    Icon(Icons.height, color: Colors.red, size: 24.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Physical Attributes',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Body Type',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Slim'),
                      value: _bodyTypes.contains(1),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _bodyTypes.add(1);
                        } else {
                          _bodyTypes.remove(1);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Athletic'),
                      value: _bodyTypes.contains(2),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _bodyTypes.add(2);
                        } else {
                          _bodyTypes.remove(2);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Average'),
                      value: _bodyTypes.contains(3),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _bodyTypes.add(3);
                        } else {
                          _bodyTypes.remove(3);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Heavy'),
                      value: _bodyTypes.contains(4),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _bodyTypes.add(4);
                        } else {
                          _bodyTypes.remove(4);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Skin Complexion',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Very Fair'),
                      value: _skinComplexions.contains(1),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _skinComplexions.add(1);
                        } else {
                          _skinComplexions.remove(1);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Fair'),
                      value: _skinComplexions.contains(2),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _skinComplexions.add(2);
                        } else {
                          _skinComplexions.remove(2);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Wheatish'),
                      value: _skinComplexions.contains(3),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _skinComplexions.add(3);
                        } else {
                          _skinComplexions.remove(3);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Dark'),
                      value: _skinComplexions.contains(4),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _skinComplexions.add(4);
                        } else {
                          _skinComplexions.remove(4);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Height Range (cm)',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _minHeight.toInt(),
                        decoration: InputDecoration(
                          labelText: 'Min Height',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        ),
                        items: _heights.map((height) {
                          return DropdownMenuItem<int>(
                            value: height,
                            child: Text('$height cm'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _minHeight = value.toDouble();
                              if (_maxHeight < value) _maxHeight = value.toDouble();
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _maxHeight.toInt(),
                        decoration: InputDecoration(
                          labelText: 'Max Height',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        ),
                        items: _heights.map((height) {
                          return DropdownMenuItem<int>(
                            value: height,
                            child: Text('$height cm'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _maxHeight = value.toDouble();
                              if (_minHeight > value) _minHeight = value.toDouble();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                RangeSlider(
                  min: kDefaultMinHeight,
                  max: kDefaultMaxHeight,
                  divisions: (kDefaultMaxHeight - kDefaultMinHeight).toInt(),
                  labels: RangeLabels(
                    '$_minHeight cm',
                    '$_maxHeight cm',
                  ),
                  values: RangeValues(_minHeight.toDouble(), _maxHeight.toDouble()),
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey[300],
                  onChanged: (RangeValues values) {
                    setState(() {
                      _minHeight = values.start;
                      _maxHeight = values.end;
                    });
                  },
                ),
                SizedBox(height: 16.h),
                Text(
                  'Weight Range (kg)',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _minWeight.toInt(),
                        decoration: InputDecoration(
                          labelText: 'Min Weight',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        ),
                        items: _weights.map((weight) {
                          return DropdownMenuItem<int>(
                            value: weight,
                            child: Text('$weight kg'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _minWeight = value.toDouble();
                              if (_maxWeight < value) _maxWeight = value.toDouble();
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _maxWeight.toInt(),
                        decoration: InputDecoration(
                          labelText: 'Max Weight',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        ),
                        items: _weights.map((weight) {
                          return DropdownMenuItem<int>(
                            value: weight,
                            child: Text('$weight kg'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _maxWeight = value.toDouble();
                              if (_minWeight > value) _minWeight = value.toDouble();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                RangeSlider(
                  min: kDefaultMinWeight,
                  max: kDefaultMaxWeight,
                  divisions: (kDefaultMaxWeight - kDefaultMinWeight).toInt(),
                  labels: RangeLabels(
                    '$_minWeight kg',
                    '$_maxWeight kg',
                  ),
                  values: RangeValues(_minWeight.toDouble(), _maxWeight.toDouble()),
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey[300],
                  onChanged: (RangeValues values) {
                    setState(() {
                      _minWeight = values.start;
                      _maxWeight = values.end;
                    });
                  },
                ),
                SizedBox(height: 24.h),
                // Career & Education Section
                Row(
                  children: [
                    Icon(Icons.work_outline, color: Colors.red, size: 24.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Career & Education',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Job Sectors
                Text(
                  'Job Sectors',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Government'),
                      value: _jobSectors.contains(1),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _jobSectors.add(1);
                        } else {
                          _jobSectors.remove(1);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                    CheckboxListTile(
                      title: const Text('Private'),
                      value: _jobSectors.contains(2),
                      onChanged: (value) => setState(() {
                        if (value!) {
                          _jobSectors.add(2);
                        } else {
                          _jobSectors.remove(2);
                        }
                      }),
                      activeColor: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Job Types
                Text(
                  'Job Types',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (_jobTypes.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _jobTypes
                        .map((type) => Chip(
                              label: Text(type),
                              onDeleted: () => setState(() => _jobTypes.remove(type)),
                              backgroundColor: Colors.red[50],
                              deleteIconColor: Colors.red,
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 8.h),
                ],
                StatefulBuilder(
                  builder: (context, dropdownSetState) {
                    final List<String> allJobTypes = [
                      'Software Engineer',
                      'Doctor',
                      'Teacher',
                      'Business Owner',
                      'Lawyer',
                      'Accountant',
                      'Marketing Professional',
                      'Sales Professional',
                      'Engineer',
                      'Others'
                    ];

                    final availableJobTypes = allJobTypes.where((type) => !_jobTypes.contains(type)).toList();

                    if (availableJobTypes.isEmpty) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          'All job types selected',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    return FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Select Job Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          ),
                          isEmpty: state.value == null || state.value!.isEmpty,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: null,
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('Select a job type'),
                              items: availableJobTypes.map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    _jobTypes.add(value);
                                  });
                                  dropdownSetState(() {
                                    state.didChange(null);
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                // Education Qualifications
                Text(
                  'Education Qualifications',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (_educationQualifications.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _educationQualifications
                        .map((edu) => Chip(
                              label: Text(edu),
                              onDeleted: () => setState(() => _educationQualifications.remove(edu)),
                              backgroundColor: Colors.red[50],
                              deleteIconColor: Colors.red,
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 8.h),
                ],
                StatefulBuilder(
                  builder: (context, dropdownSetState) {
                    final List<String> allQualifications = [
                      'High School',
                      'Bachelors Degree',
                      'Masters Degree',
                      'PhD',
                      'Diploma',
                      'Professional Certification',
                      'Others'
                    ];

                    final availableQualifications =
                        allQualifications.where((qual) => !_educationQualifications.contains(qual)).toList();

                    if (availableQualifications.isEmpty) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          'All qualifications selected',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    return FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Select Qualification',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          ),
                          isEmpty: state.value == null || state.value!.isEmpty,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: null,
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('Select a qualification'),
                              items: availableQualifications.map((String qual) {
                                return DropdownMenuItem<String>(
                                  value: qual,
                                  child: Text(qual),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    _educationQualifications.add(value);
                                  });
                                  dropdownSetState(() {
                                    state.didChange(null);
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                // Salary Section
                Text(
                  'Salary',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                // Currency Dropdown
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Currency',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      ),
                      isEmpty: _selectedCurrency == null,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCurrency,
                          isDense: true,
                          isExpanded: true,
                          hint: const Text('Select currency'),
                          items: [
                            'USD',
                            'EUR',
                            'GBP',
                            'INR',
                            'LKR',
                          ].map((String currency) {
                            return DropdownMenuItem<String>(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedCurrency = value;
                              _currency = value;
                            });
                            state.didChange(value);
                          },
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Min Salary',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onChanged: (v) => setState(() => _minSalary = double.tryParse(v)),
                        controller: TextEditingController(text: _minSalary?.toString() ?? ''),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Max Salary',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onChanged: (v) => setState(() => _maxSalary = double.tryParse(v)),
                        controller: TextEditingController(text: _maxSalary?.toString() ?? ''),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Currency (e.g., LKR, USD)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onChanged: (v) => setState(() => _currency = v.isEmpty ? null : v),
                  controller: TextEditingController(text: _currency ?? ''),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Checkbox(
                      value: _isAnnual ?? true,
                      activeColor: Colors.red,
                      onChanged: (v) => setState(() => _isAnnual = v),
                    ),
                    Text(
                      'Annual',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Astrology Section
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.red, size: 24.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Astrology',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Nakshathiram Dropdown
                Text(
                  'Nakshathiram',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (_nakshathiram.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _nakshathiram
                        .map((star) => Chip(
                              label: Text(star),
                              onDeleted: () => setState(() => _nakshathiram.remove(star)),
                              backgroundColor: Colors.red[50],
                              deleteIconColor: Colors.red,
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 8.h),
                ],
                StatefulBuilder(
                  builder: (context, dropdownSetState) {
                    final List<String> allNakshathirams = [
                      'Ashwini',
                      'Bharani',
                      'Krittika',
                      'Rohini',
                      'Mrigashira',
                      'Ardra',
                      'Punarvasu',
                      'Pushya',
                      'Ashlesha',
                      'Magha',
                      'Purva Phalguni',
                      'Uttara Phalguni',
                      'Hasta',
                      'Chitra',
                      'Swati',
                      'Vishaka',
                      'Anuradha',
                      'Jyeshtha',
                      'Mula',
                      'Purva Ashadha',
                      'Uttara Ashadha',
                      'Shravana',
                      'Dhanishta',
                      'Shatabhisha',
                      'Purva Bhadrapada',
                      'Uttara Bhadrapada',
                      'Revati'
                    ];

                    final availableNakshathirams = allNakshathirams.where((star) => !_nakshathiram.contains(star)).toList();

                    if (availableNakshathirams.isEmpty) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          'All Nakshathirams selected',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    return FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Select Nakshathiram',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          ),
                          isEmpty: state.value == null || state.value!.isEmpty,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: null,
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('Select a Nakshathiram'),
                              items: availableNakshathirams.map((String star) {
                                return DropdownMenuItem<String>(
                                  value: star,
                                  child: Text(star),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    _nakshathiram.add(value);
                                  });
                                  dropdownSetState(() {
                                    state.didChange(null);
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                // Raasi Dropdown
                Text(
                  'Raasi',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (_raasi.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _raasi
                        .map((sign) => Chip(
                              label: Text(sign),
                              onDeleted: () => setState(() => _raasi.remove(sign)),
                              backgroundColor: Colors.red[50],
                              deleteIconColor: Colors.red,
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 8.h),
                ],
                StatefulBuilder(
                  builder: (context, dropdownSetState) {
                    final List<String> allRaasis = [
                      'Mesha (Aries)',
                      'Vrishabha (Taurus)',
                      'Mithuna (Gemini)',
                      'Karkata (Cancer)',
                      'Simha (Leo)',
                      'Kanya (Virgo)',
                      'Tula (Libra)',
                      'Vrischika (Scorpio)',
                      'Dhanu (Sagittarius)',
                      'Makara (Capricorn)',
                      'Kumbha (Aquarius)',
                      'Meena (Pisces)'
                    ];

                    final availableRaasis = allRaasis.where((sign) => !_raasi.contains(sign)).toList();

                    if (availableRaasis.isEmpty) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          'All Raasis selected',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    return FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Select Raasi',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          ),
                          isEmpty: state.value == null || state.value!.isEmpty,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: null,
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('Select a Raasi'),
                              items: availableRaasis.map((String sign) {
                                return DropdownMenuItem<String>(
                                  value: sign,
                                  child: Text(sign),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    _raasi.add(value);
                                  });
                                  dropdownSetState(() {
                                    state.didChange(null);
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                // Clear Astrology button
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _nakshathiram.clear();
                        _raasi.clear();
                      });
                    },
                    icon: const Icon(Icons.clear, color: Colors.red),
                    label: Text(
                      'Clear Astrology',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
