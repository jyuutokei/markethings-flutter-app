import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/profile_entity.dart';
import 'package:mt/features/home/domain/usecases/get_user_profile.dart';
import 'package:mt/features/home/presentation/widgets/appbar_main.dart';
import 'package:mt/features/home/presentation/widgets/profile_header.dart';
import 'package:mt/features/home/presentation/widgets/sidebar.dart';
import 'package:mt/injection_container.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = sl<SupabaseClient>().auth.currentUser;
  late ProfileEntity _profile;
  bool _isLoading = true;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sbxController = SidebarXController(selectedIndex: 0, extended: true);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await sl<GetUserProfile>().call(user!.id);

      if (!mounted) return;
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (error) {
      AppHelpers.logger().error(error);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarNav(controller: _sbxController),
      appBar: AppBarMain(scaffoldKey: _scaffoldKey, title: "Profile"),
      body: _isLoading
          ? const Center(child: SpinKitPumpingHeart(color: Colors.white))
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ProfileHeader(avatarUrl: _profile.avatarUrl),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          _profile.displayName,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Gap(defaultPadding),
                        ListTile(
                          leading: const Icon(
                            Icons.shopping_bag,
                            color: Colors.white,
                          ),
                          title: const Text("My Orders"),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.pushNamed(AppRoute.orders);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
