import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/profile_entity.dart';
import 'package:mt/features/home/domain/usecases/get_user_profile.dart';
import 'package:mt/injection_container.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SidebarNav extends StatefulWidget {
  final SidebarXController _controller;

  const SidebarNav({required this._controller, super.key});

  @override
  State<SidebarNav> createState() => _SidebarNavState();
}

class _SidebarNavState extends State<SidebarNav> {
  final user = sl<SupabaseClient>().auth.currentUser;
  late ProfileEntity _profile;
  bool _isLoading = true;

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
    return SidebarX(
      controller: widget._controller,
      showToggleButton: false,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppHelpers.primaryColor(context),
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Colors.white.withValues(alpha: 0.12),
        hoverTextStyle: const TextStyle(color: Colors.white),
        hoverIconTheme: const IconThemeData(color: Colors.white),
        textStyle: const TextStyle(color: Colors.white),
        selectedTextStyle: TextStyle(
          color: AppHelpers.primaryColor(context),
          fontWeight: FontWeight.bold,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          border: Border.all(color: AppHelpers.primaryColor(context)),
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        selectedItemDecoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        selectedIconTheme: IconThemeData(
          color: AppHelpers.primaryColor(context),
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(color: AppHelpers.primaryColor(context)),
      ),
      headerBuilder: (context, extended) {
        return SafeArea(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? const SpinKitRing(color: Colors.white)
                  : Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              _profile.avatarUrl ??
                              'https://static.wikia.nocookie.net/zenless-zone-zero/images/5/53/Avatar_Default_Anonymous.png/revision/latest?cb=20240725210433',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const SpinKitRing(color: Colors.white),
                          errorBuilder: (context, url, error) =>
                              const Icon(Icons.error),
                        ),

                        const Gap(defaultPadding),
                        Text(
                          _profile.displayName,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Gap(defaultPadding),
                        const Divider(),
                      ],
                    ),
            ),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.logout,
          label: 'Sign out',
          onTap: () {
            sl<SupabaseClient>().auth.signOut();
          },
        ),
      ],
    );
  }
}
