import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static final String spbUrl = _Env.spbUrl;
  @EnviedField(varName: 'SUPABASE_PBKEY')
  static final String spbPbkey = _Env.spbPbkey;
}
