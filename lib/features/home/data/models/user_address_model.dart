import 'package:mt/features/home/domain/entities/user_address_entity.dart';

class UserAddressModel extends UserAddressEntity {
  const UserAddressModel({
    required super.id,
    required super.userId,
    required super.recipientName,
    required super.phoneNumber,
    required super.streetAddress,
    super.extendedAddress,
    super.neighborhood,
    required super.cityOrMunicipality,
    required super.stateOrProvince,
    required super.postalCode,
    required super.country,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      recipientName: json['recipient_name'] as String,
      phoneNumber: json['phone_number'] as String,
      streetAddress: json['street_address'] as String,
      extendedAddress: json['extended_address'] as String?,
      neighborhood: json['neighborhood'] as String?,
      cityOrMunicipality: json['city_or_municipality'] as String,
      stateOrProvince: json['state_or_province'] as String,
      postalCode: json['postal_code'] as String,
      country: json['country'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'recipient_name': recipientName,
      'phone_number': phoneNumber,
      'street_address': streetAddress,
      'extended_address': extendedAddress,
      'neighborhood': neighborhood,
      'city_or_municipality': cityOrMunicipality,
      'state_or_province': stateOrProvince,
      'postal_code': postalCode,
      'country': country,
    };
  }
}
