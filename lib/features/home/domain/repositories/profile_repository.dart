import 'package:mt/features/home/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getUserProfile(String userId);
}
