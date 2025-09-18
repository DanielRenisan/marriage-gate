import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleMapsService {
  static const String _apiKey = 'AIzaSyAoyHKkR4lPW6riz_RuEol1ZOt1MEswA3I';
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';

  /// Test if the API key is working
  static Future<bool> testApiKey() async {
    try {
      final url = Uri.parse(
        '$_baseUrl/place/autocomplete/json?input=test&key=$_apiKey&types=address'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] != 'REQUEST_DENIED';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get place predictions based on input text
  static Future<List<PlacePrediction>> getPlacePredictions(String input) async {
    try {
      final encodedInput = Uri.encodeComponent(input);
      final url = Uri.parse(
        '$_baseUrl/place/autocomplete/json?input=$encodedInput&key=$_apiKey&types=address'
      );
      
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          final result = predictions.map((prediction) => PlacePrediction.fromJson(prediction)).toList();
          return result;
        } else {
        }
      } else {
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get place details by place ID
  static Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/place/details/json?place_id=$placeId&key=$_apiKey&fields=address_components,formatted_address,geometry'
      );
      
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final result = data['result'];
          return PlaceDetails.fromJson(result);
        } else {
        }
      } else {
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

class PlacePrediction {
  final String placeId;
  final String description;

  PlacePrediction({
    required this.placeId,
    required this.description,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['place_id'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class PlaceDetails {
  final String formattedAddress;
  final double latitude;
  final double longitude;
  final String? streetNumber;
  final String? route;
  final String? locality;
  final String? administrativeAreaLevel1;
  final String? country;
  final String? postalCode;

  PlaceDetails({
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    this.streetNumber,
    this.route,
    this.locality,
    this.administrativeAreaLevel1,
    this.country,
    this.postalCode,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] ?? {};
    final location = geometry['location'] ?? {};
    final addressComponents = json['address_components'] as List? ?? [];

    String? streetNumber;
    String? route;
    String? locality;
    String? administrativeAreaLevel1;
    String? country;
    String? postalCode;

    for (final component in addressComponents) {
      final types = List<String>.from(component['types'] ?? []);
      
      if (types.contains('street_number')) {
        streetNumber = component['long_name'];
      } else if (types.contains('route')) {
        route = component['long_name'];
      } else if (types.contains('locality')) {
        locality = component['long_name'];
      } else if (types.contains('administrative_area_level_1')) {
        administrativeAreaLevel1 = component['long_name'];
      } else if (types.contains('country')) {
        country = component['long_name'];
      } else if (types.contains('postal_code')) {
        postalCode = component['long_name'];
      }
    }

    return PlaceDetails(
      formattedAddress: json['formatted_address'] ?? '',
      latitude: (location['lat'] ?? 0.0).toDouble(),
      longitude: (location['lng'] ?? 0.0).toDouble(),
      streetNumber: streetNumber,
      route: route,
      locality: locality,
      administrativeAreaLevel1: administrativeAreaLevel1,
      country: country,
      postalCode: postalCode,
    );
  }
}
