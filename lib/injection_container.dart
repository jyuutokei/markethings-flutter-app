import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

final sl = GetIt.instance;

void setupLocator() async {
  // talker
  sl.registerSingleton(TalkerFlutter.init());
  sl.registerSingleton(TalkerRouteObserver(Talker()));
}
