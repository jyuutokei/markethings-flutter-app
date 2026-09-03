import 'package:get_it/get_it.dart';
import 'package:mt/features/auth/data/repository/auth_repo_impl.dart';
import 'package:mt/features/auth/domain/repository/auth_repo.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:mt/config/env/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

void setupLocator() async {
  //supabase
  await Supabase.initialize(url: Env.spbUrl, publishableKey: Env.spbPbkey);
  sl.registerSingleton<SupabaseClient>(Supabase.instance.client);
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl<SupabaseClient>()));

  // talker
  sl.registerSingleton<Talker>(TalkerFlutter.init());
  sl.registerSingleton<TalkerRouteObserver>(TalkerRouteObserver(Talker()));
  sl.registerSingleton<TalkerLogger>(TalkerLogger());
}
