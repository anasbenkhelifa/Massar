import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/company_model.dart';

class MapApiService {
  static const String baseUrl = 'https://massar-backend.onrender.com/api/v1';

  Future<({LatLng center, List<Company> companies})> getProfileCompanies({
    double radiusKm = 50.0,
    bool live = false,
  }) async {
    try {
      // Read wilaya from onboarding data stored locally
      final prefs = await SharedPreferences.getInstance();
      int? wilayaCode;
      final onboardingJson = prefs.getString('massar_onboarding_state');
      if (onboardingJson != null) {
        try {
          final map = json.decode(onboardingJson) as Map<String, dynamic>;
          wilayaCode = (map['wilayaCode'] as num?)?.toInt() ??
              (map['homeWilayaCode'] as num?)?.toInt();
        } catch (_) {}
      }

      // Build URL — use public /companies endpoint (no auth needed)
      final params = {
        'radius_km': radiusKm.toString(),
        'live': live.toString(),
        if (wilayaCode != null) 'wilaya': wilayaCode.toString(),
      };
      final uri = Uri.parse('$baseUrl/map/companies').replace(queryParameters: params);

      final response = await http.get(uri).timeout(
        const Duration(seconds: 25),
        onTimeout: () => throw Exception('Request timed out'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> companiesJson = data['companies'] ?? [];
        final companies =
            companiesJson.map((j) => Company.fromJson(j)).toList();

        // Use center returned by backend, else wilaya center, else Algiers
        double lat = 36.7367;
        double lng = 3.0869;
        if (data['center'] != null) {
          lat = (data['center']['lat'] as num?)?.toDouble() ?? lat;
          lng = (data['center']['lng'] as num?)?.toDouble() ?? lng;
        }

        return (center: LatLng(lat, lng), companies: companies);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error ${response.statusCode}');
      } else {
        return _getMockData();
      }
    } catch (_) {
      return _getMockData();
    }
  }

  /// Static mock data for development — removed once backend is live.
  static ({LatLng center, List<Company> companies}) _getMockData() {
    final companies = [
      Company(
        id: 'mock-1',
        name: 'Sonatrach',
        nameAr: 'سوناطراك',
        type: 'Entreprise nationale',
        domains: ['engineering', 'energy'],
        relevantMajors: ['Génie pétrolier', 'Génie mécanique'],
        wilayaCode: 16,
        commune: 'Hydra',
        address: 'Djenane El Malik, Hydra',
        latitude: 36.7429,
        longitude: 3.0218,
        description:
            'Société nationale pour la recherche, exploitation et commercialisation des hydrocarbures.',
        internshipLikelihood: 'high',
        tags: ['Énergie', 'Pétrole', 'Stage PFE'],
        distanceKm: 3.2,
        source: 'static',
      ),
      Company(
        id: 'mock-2',
        name: 'Djezzy',
        nameAr: 'جازي',
        type: 'Télécommunications',
        domains: ['technology', 'it'],
        relevantMajors: ['Informatique', 'Télécommunications'],
        wilayaCode: 16,
        commune: 'Bab Ezzouar',
        address: 'Cité 8 Mai 45, Bab Ezzouar',
        latitude: 36.7208,
        longitude: 3.1832,
        description:
            'Opérateur de télécommunications mobiles leader en Algérie.',
        internshipLikelihood: 'high',
        tags: ['Tech', 'Télécom', 'Stage'],
        distanceKm: 5.1,
        source: 'static',
      ),
      Company(
        id: 'mock-3',
        name: 'Cevital',
        nameAr: 'سيفيتال',
        type: 'Groupe industriel',
        domains: ['business', 'manufacturing'],
        relevantMajors: ['Gestion', 'Génie industriel'],
        wilayaCode: 6,
        commune: 'Béjaïa',
        address: 'Port de Béjaïa',
        latitude: 36.7509,
        longitude: 5.0567,
        description:
            'Premier groupe privé algérien, actif dans l\'agroalimentaire, l\'industrie et l\'électronique.',
        internshipLikelihood: 'medium',
        tags: ['Industrie', 'Agroalimentaire'],
        distanceKm: 260.0,
        source: 'static',
      ),
      Company(
        id: 'mock-4',
        name: 'CHU Mustapha Pacha',
        nameAr: 'مستشفى مصطفى باشا',
        type: 'Établissement hospitalier',
        domains: ['medicine', 'health'],
        relevantMajors: ['Médecine', 'Pharmacie', 'Biologie'],
        wilayaCode: 16,
        commune: 'Sidi M\'hamed',
        address: 'Place du 1er Mai, Sidi M\'hamed',
        latitude: 36.7602,
        longitude: 3.0572,
        description:
            'Centre hospitalo-universitaire de référence pour la formation médicale en Algérie.',
        internshipLikelihood: 'high',
        tags: ['Santé', 'Formation', 'Stage hospitalier'],
        distanceKm: 1.8,
        source: 'static',
      ),
      Company(
        id: 'mock-5',
        name: 'Cosider Groupe',
        nameAr: 'كوسيدار',
        type: 'Entreprise BTP',
        domains: ['engineering', 'manufacturing'],
        relevantMajors: ['Génie civil', 'Architecture'],
        wilayaCode: 16,
        commune: 'Les Eucalyptus',
        address: 'Route de l\'aéroport, Les Eucalyptus',
        latitude: 36.6932,
        longitude: 3.1581,
        description:
            'Leader algérien du bâtiment et des travaux publics.',
        internshipLikelihood: 'medium',
        tags: ['BTP', 'Construction', 'Infrastructure'],
        distanceKm: 8.5,
        source: 'static',
      ),
      Company(
        id: 'mock-6',
        name: 'Mobilis',
        nameAr: 'موبيليس',
        type: 'Télécommunications',
        domains: ['technology', 'it'],
        relevantMajors: ['Informatique', 'Réseaux'],
        wilayaCode: 16,
        commune: 'El Harrach',
        address: 'Quartier d\'affaires, El Harrach',
        latitude: 36.7167,
        longitude: 3.1333,
        description:
            'Opérateur public de téléphonie mobile en Algérie.',
        internshipLikelihood: 'medium',
        tags: ['Télécom', 'IT', 'Mobile'],
        distanceKm: 6.0,
        source: 'static',
      ),
      Company(
        id: 'mock-7',
        name: 'Saidal',
        nameAr: 'صيدال',
        type: 'Industrie pharmaceutique',
        domains: ['pharma', 'health'],
        relevantMajors: ['Pharmacie', 'Chimie', 'Biologie'],
        wilayaCode: 16,
        commune: 'El Harrach',
        address: 'Zone industrielle, El Harrach',
        latitude: 36.7201,
        longitude: 3.1412,
        description:
            'Groupe pharmaceutique public algérien, production de médicaments génériques.',
        internshipLikelihood: 'high',
        tags: ['Pharma', 'Santé', 'R&D'],
        distanceKm: 5.8,
        source: 'static',
      ),
      Company(
        id: 'mock-8',
        name: 'Tribunal de Sidi M\'hamed',
        nameAr: 'محكمة سيدي امحمد',
        type: 'Institution judiciaire',
        domains: ['law', 'government'],
        relevantMajors: ['Droit', 'Sciences politiques'],
        wilayaCode: 16,
        commune: 'Sidi M\'hamed',
        address: 'Rue Abane Ramdane, Sidi M\'hamed',
        latitude: 36.7580,
        longitude: 3.0540,
        description:
            'Juridiction de premier degré pour les stages en droit.',
        internshipLikelihood: 'high',
        tags: ['Droit', 'Justice', 'Stage PFE'],
        distanceKm: 2.1,
        source: 'static',
      ),
    ];

    return (center: const LatLng(36.7367, 3.0869), companies: companies);
  }
}
