import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: widget._controller,
      showToggleButton: false,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Colors.white.withValues(alpha: 0.12),
        hoverTextStyle: const TextStyle(color: Colors.white),
        hoverIconTheme: const IconThemeData(color: Colors.white),
        textStyle: const TextStyle(color: Colors.white),
        selectedTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        selectedItemDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          border: Border.all(color: Theme.of(context).colorScheme.onPrimary),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      ),
      headerBuilder: (context, extended) {
        return SafeArea(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset('assets/images/sample/avatar.png'),
                  const Gap(defaultPadding),
                  Text(
                    user?.email ?? "",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
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
