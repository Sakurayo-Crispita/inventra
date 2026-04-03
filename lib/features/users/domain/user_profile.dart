import 'package:flutter/foundation.dart';

/// Enum para representar los roles permitidos en Inventra.
enum UserRole {
  admin('admin'),
  supervisor('supervisor'),
  operador('operador');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (r) => r.value == role.toLowerCase(),
      orElse: () => UserRole.operador,
    );
  }

  @override
  String toString() => value;
}

/// Entidad de dominio para el Perfil de Usuario.
///
/// Refleja la información administrativa almacenada en `public.profiles`.
@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? 'Usuario sin nombre',
      email: json['email'] as String,
      role: UserRole.fromString(json['role'] as String? ?? 'operador'),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role.value,
      'is_active': isActive,
    };
  }

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'UserProfile(id: $id, name: $fullName, role: $role, active: $isActive)';
}
