import 'dart:convert';

import '../models/country.dart';
import '../models/state.dart';
import '../models/city.dart';
import 'api_service.dart';

/// A service class for handling location-related API requests
/// This class provides methods for fetching countries, states, and cities from the API.
class LocationService {

  /// Fetches a list of countries from the API.
  static Future<List<Country>> getCountries() async {
    final response = await ApiService.getRequest('countries');

    if (response.statusCode == 200 && response.data != null) {
      try {
        final rawData = response.data;
        final List<dynamic> jsonList = rawData is String ? jsonDecode(rawData) : rawData;

        return jsonList.map((json) => Country.fromJson(json)).toList();
      } catch (e) {
        print('Error parsing countries: $e');
        return [];
      }
    } else {
      // Handle error or return empty list
      return [];
    }
  }

  /// Fetches a list of states for a given country ID from the API.
  static Future<List<StateModel>> getStates(int countryId) async {
    final response = await ApiService.getRequest('countries/$countryId/states');

    if (response.statusCode == 200 && response.data != null) {
      try {
        final rawData = response.data;
        final List<dynamic> jsonList = rawData is String ? jsonDecode(rawData) : rawData;

        return jsonList.map((json) => StateModel.fromJson(json)).toList();
      } catch (e) {
        print('Error parsing countries: $e');
        return [];
      }
    } else {
      // Handle error or return empty list
      return [];
    }
  }

  /// Fetches a list of cities for a given state ID from the API, with pagination support.
  static Future<List<City>> getCities(int stateId, int page, int size) async {
    final response = await ApiService.getRequest('states/$stateId/cities?page=$page&size=$size');

    if (response.statusCode == 200 && response.data != null) {
      try {
        final rawData = response.data;
        final Map<String, dynamic> decoded = rawData is String ? jsonDecode(rawData) : rawData;
        final List<dynamic> cityList = decoded['content'] ?? [];

        return cityList.map((json) => City.fromJson(json)).toList();
      } catch (e) {
        print('Error parsing countries: $e');
        return [];
      }
    } else {
      // Handle error or return empty list
      return [];
    }
  }

}