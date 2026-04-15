import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../models/company_model.dart';
import '../../services/map_api_service.dart';

class MapScreen extends ConsumerStatefulWidget {
  final bool standalone;
  const MapScreen({super.key, this.standalone = true});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  final MapApiService _apiService = MapApiService();

  List<Company> _companies = [];
  bool _isLoading = true;
  LatLng _center = const LatLng(36.7367, 3.0869); // Default Algiers

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.getProfileCompanies(radiusKm: 50.0, live: false);
      setState(() {
        _companies = result.companies;
        _isLoading = false;
        _center = result.center;
      });
      // Move map after a slight delay to ensure it's rendered
      Future.delayed(const Duration(milliseconds: 100), () {
        _mapController.move(_center, 12);
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Color _getPinColor(Company company) {
    if (company.domains.contains('technology') || company.domains.contains('it')) return Colors.blue;
    if (company.domains.contains('engineering') || company.domains.contains('manufacturing')) return Colors.orange;
    if (company.domains.contains('medicine') || company.domains.contains('pharma') || company.domains.contains('health')) return Colors.green;
    if (company.domains.contains('business') || company.domains.contains('finance')) return Colors.yellow;
    if (company.domains.contains('law') || company.domains.contains('government')) return Colors.purple;
    if (company.domains.contains('agriculture')) return Colors.green[800]!;
    return AppColors.accent; // Default
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg1 = isDark ? AppColors.background1 : const Color(0xFFF2F5FB);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg1,
      body: Stack(
        children: [
          // Flutter Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 12.0,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.massar.app',
              ),
              MarkerLayer(
                markers: _companies.map((c) => Marker(
                  point: LatLng(c.latitude, c.longitude),
                  width: 48,
                  height: 48,
                  child: GestureDetector(
                    onTap: () => _showCompanyDetails(context, c, isDark),
                    child: _MapPin(
                      color: _getPinColor(c),
                      isVerified: c.source == 'static',
                    ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
                  ),
                )).toList(),
              ),
            ],
          ),

          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  if (widget.standalone) ...[
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.glassFill : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: textSecondary, size: 16),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.glassFill : Colors.white.withAlpha(200),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(15)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.map_rounded, color: AppColors.accent, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              l.homeNavGuide, // Use the map localized string ("Map" / "الدليل")
                              style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: isDark ? Colors.black.withAlpha(100) : Colors.white.withAlpha(100),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
            ),
        ],
      ),
    );
  }

  void _showCompanyDetails(BuildContext context, Company c, bool isDark) {
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xED0D1425) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(15))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4, 
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18), 
                      borderRadius: BorderRadius.circular(2)
                    )
                  )
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: _getPinColor(c).withAlpha(30),
                        shape: BoxShape.circle,
                        border: Border.all(color: _getPinColor(c).withAlpha(100)),
                      ),
                      child: Icon(Icons.business_rounded, color: _getPinColor(c)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(c.name, style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                              if (c.source == 'static') ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded, color: AppColors.accent, size: 16),
                              ]
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(c.type, style: TextStyle(color: textSecondary, fontSize: 13)),
                        ]
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 16, color: textSecondary),
                    const SizedBox(width: 6),
                    Expanded(child: Text('${c.commune}, $_resolveWilaya(c.wilayaCode)', style: TextStyle(color: textSecondary, fontSize: 14))),
                  ],
                ),
                const SizedBox(height: 16),
                Text(c.description, style: TextStyle(color: textSecondary, fontSize: 14, height: 1.6)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: c.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.secondary.withAlpha(50)),
                    ),
                    child: Text(tag, style: const TextStyle(color: AppColors.secondary, fontSize: 12)),
                  )).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('طلب معلومات', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _resolveWilaya(int code) {
    // Basic resolver
    if (code == 16) return 'Alger';
    // Ideally use kWilayas from lib/data/wilayas.dart
    return 'Wilaya $code';
  }
}

class _MapPin extends StatelessWidget {
  final Color color;
  final bool isVerified;
  const _MapPin({required this.color, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.location_on, color: color, size: 40),
        if (isVerified)
          Positioned(
            top: 4,
            child: Container(
              width: 10, height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified, color: AppColors.accent, size: 10),
            ),
          )
      ],
    );
  }
}
