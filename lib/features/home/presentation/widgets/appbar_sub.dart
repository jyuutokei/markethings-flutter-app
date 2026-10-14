import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';

class AppBarSub extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarSub({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(
        color: Colors.black,
        onPressed: () {
          context.pop();
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/Location.svg"),
          const Gap(defaultPadding / 2),
          Text(title),
          const Gap(defaultPadding * 2),
        ],
      ),
    );
  }
}
