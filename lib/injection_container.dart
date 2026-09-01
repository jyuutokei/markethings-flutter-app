import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:mt/config/env/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

void setupLocator() async {
  //supabase
  await Supabase.initialize(url: Env.spbUrl, publishableKey: Env.spbPbkey);
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // talker
  sl.registerSingleton<Talker>(TalkerFlutter.init());
  sl.registerSingleton<TalkerRouteObserver>(TalkerRouteObserver(Talker()));
  sl.registerSingleton<TalkerLogger>(TalkerLogger());
}
