import 'package:mt/features/home/domain/entities/profile_entity.dart';
import 'package:mt/features/home/domain/repositories/profile_repository.dart';

class GetUserProfile {
  final ProfileRepository repository;

  const GetUserProfile(this.repository);

  Future<ProfileEntity> call(String userId) {
    return repository.getUserProfile(userId);
  }
}
