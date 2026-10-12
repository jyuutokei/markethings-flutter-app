import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getUserProfile(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _client;

  const ProfileRemoteDataSourceImpl(this._client);

  @override
  Future<ProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select('id, display_name, store_name, avatar_url')
          .eq('id', userId)
          .single();

      return ProfileModel.fromJson(response);
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
