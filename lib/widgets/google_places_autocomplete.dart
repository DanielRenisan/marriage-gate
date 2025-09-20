import 'package:flutter/material.dart';
import '../services/google_maps_service.dart';

class GooglePlacesAutocomplete extends StatefulWidget {
  final String label;
  final String? hint;
  final String? initialValue;
  final Function(PlaceDetails) onPlaceSelected;
  final String? Function(String?)? validator;
  final bool isRequired;

  const GooglePlacesAutocomplete({
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    required this.onPlaceSelected,
    this.validator,
    this.isRequired = false,
  });

  @override
  State<GooglePlacesAutocomplete> createState() => _GooglePlacesAutocompleteState();
}

class _GooglePlacesAutocompleteState extends State<GooglePlacesAutocomplete> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<PlacePrediction> _predictions = [];
  bool _isLoading = false;
  bool _showPredictions = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Add a small delay before hiding predictions to allow for tap
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!_focusNode.hasFocus) {
          setState(() {
            _showPredictions = false;
          });
        }
      });
    } else {
      // Show predictions when focused if we have them
      if (_predictions.isNotEmpty) {
        setState(() {
          _showPredictions = true;
        });
      }
    }
  }

  Future<void> _onTextChanged(String value) async {

    if (value.length < 3) {
      setState(() {
        _predictions = [];
        _showPredictions = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showPredictions = false;
    });

    try {
      final predictions = await GoogleMapsService.getPlacePredictions(value);

      // If no predictions from Google, create some test predictions for debugging
      List<PlacePrediction> finalPredictions = predictions;
      if (predictions.isEmpty && value.length >= 3) {
        finalPredictions = [
          PlacePrediction(placeId: 'test1', description: '$value, Test City, Test Country'),
          PlacePrediction(placeId: 'test2', description: '$value Street, Test City, Test Country'),
          PlacePrediction(placeId: 'test3', description: '$value Road, Test City, Test Country'),
        ];
      }

      setState(() {
        _predictions = finalPredictions;
        _showPredictions = finalPredictions.isNotEmpty;
        _isLoading = false;
      });


      if (finalPredictions.isNotEmpty) {
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _showPredictions = false;
      });
    }
  }

  Future<void> _onPredictionSelected(PlacePrediction prediction) async {
    setState(() {
      _controller.text = prediction.description;
      _showPredictions = false;
      _isLoading = true;
    });

    try {

      // Handle test predictions
      if (prediction.placeId.startsWith('test')) {
        final testPlaceDetails = PlaceDetails(
          formattedAddress: prediction.description,
          latitude: 0.0,
          longitude: 0.0,
          streetNumber: '',
          route: prediction.description.split(',')[0].trim(),
          locality: prediction.description.split(',')[1].trim(),
          administrativeAreaLevel1: prediction.description.split(',')[2].trim(),
          country: 'Test Country',
          postalCode: '',
        );
        widget.onPlaceSelected(testPlaceDetails);
      } else {
        final placeDetails = await GoogleMapsService.getPlaceDetails(prediction.placeId);
        if (placeDetails != null) {
          widget.onPlaceSelected(placeDetails);
        } else {
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        if (widget.isRequired)
          const Text(
            ' *',
            style: TextStyle(color: Colors.red),
          ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onTextChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint ?? 'Search address...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            suffixIcon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.search, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
        ),
        // Show predictions below the search field
        if (_showPredictions && _predictions.isNotEmpty) ...[
          Builder(
            builder: (context) {
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _predictions.take(5).map((prediction) {
                return InkWell(
                  onTap: () => _onPredictionSelected(prediction),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200]!,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            prediction.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
