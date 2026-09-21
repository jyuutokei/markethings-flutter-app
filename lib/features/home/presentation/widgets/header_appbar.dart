import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mt/core/constants/constants.dart';

class HeaderAppbar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final String title;

  const HeaderAppbar({
    required this._scaffoldKey,
    required this.title,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: SvgPicture.asset("assets/icons/menu.svg"),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/Location.svg"),
          const SizedBox(width: defaultPadding / 2),
          Text(title),
        ],
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/Notification.svg",
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
