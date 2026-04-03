import 'package:flutter/foundation.dart';

/// Modelo inmutable de la configuración global del negocio.
///
/// Refleja la información almacenada en la tabla `public.settings`.
@immutable
class BusinessSettings {
  const BusinessSettings({
    required this.id,
    required this.businessName,
    required this.currency,
    required this.timezone,
    this.contactEmail,
    required this.updatedAt,
  });

  final int id;
  final String businessName;
  final String currency;
  final String timezone;
  final String? contactEmail;
  final DateTime updatedAt;

  factory BusinessSettings.fromJson(Map<String, dynamic> json) {
    return BusinessSettings(
      id: json['id'] as int,
      businessName: json['business_name'] as String,
      currency: json['currency'] as String,
      timezone: json['timezone'] as String,
      contactEmail: json['contact_email'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_name': businessName,
      'currency': currency,
      'timezone': timezone,
      'contact_email': contactEmail,
    };
  }

  BusinessSettings copyWith({
    int? id,
    String? businessName,
    String? currency,
    String? timezone,
    String? contactEmail,
    DateTime? updatedAt,
  }) {
    return BusinessSettings(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
      contactEmail: contactEmail ?? this.contactEmail,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'BusinessSettings(name: $businessName, currency: $currency, timezone: $timezone)';
}
