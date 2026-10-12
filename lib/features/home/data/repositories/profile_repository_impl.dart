import 'package:mt/features/home/data/datasources/profile_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/profile_entity.dart';
import 'package:mt/features/home/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileEntity> getUserProfile(String userId) {
    return remoteDataSource.getUserProfile(userId);
  }
}
