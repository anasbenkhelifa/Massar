import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/company_model.dart';

class MapApiService {
  // Use Render deployment URL or localhost if not deploying yet.
  static const String baseUrl = 'https://massar.onrender.com/api/v1';
  static const String placeholderToken = 'placeholder-token';

  Future<({LatLng center, List<Company> companies})> getProfileCompanies({
    double radiusKm = 50.0,
    bool live = false,
  }) async {
    try {
      final uri = Uri.parse(
          '$baseUrl/map/profile-companies?radius_km=$radiusKm&live=$live');
      final response = await http.get(
        uri,
        headers: {
          // TODO: Get real Auth Token from auth_provider/shared_prefs
          'Authorization': 'Bearer $placeholderToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> companiesJson = data['companies'] ?? [];
        final companies = companiesJson.map((json) => Company.fromJson(json)).toList();
        
        double lat = 36.7367;
        double lng = 3.0869;
        if (data['center'] != null) {
          lat = (data['center']['lat'] as num?)?.toDouble() ?? lat;
          lng = (data['center']['lng'] as num?)?.toDouble() ?? lng;
        }

        return (center: LatLng(lat, lng), companies: companies);
      } else {
        return (center: const LatLng(36.7367, 3.0869), companies: []);
      }
    } catch (e) {
      return (center: const LatLng(36.7367, 3.0869), companies: []);
    }
  }
}

