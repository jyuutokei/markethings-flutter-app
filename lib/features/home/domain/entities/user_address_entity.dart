import 'package:equatable/equatable.dart';

class UserAddressEntity extends Equatable {
  final int id;
  final String userId;
  final String recipientName;
  final String phoneNumber;
  final String streetAddress;
  final String? extendedAddress;
  final String? neighborhood;
  final String cityOrMunicipality;
  final String stateOrProvince;
  final String postalCode;
  final String country;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserAddressEntity({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phoneNumber,
    required this.streetAddress,
    this.extendedAddress,
    this.neighborhood,
    required this.cityOrMunicipality,
    required this.stateOrProvince,
    required this.postalCode,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    recipientName,
    phoneNumber,
    streetAddress,
    extendedAddress,
    neighborhood,
    cityOrMunicipality,
    stateOrProvince,
    postalCode,
    country,
    createdAt,
    updatedAt,
  ];
}
