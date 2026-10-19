import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';

class SearchFormFake extends StatelessWidget {
  final String? searchQuery;
  const SearchFormFake({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        onTap: () {
          if (searchQuery != null) {
            context.pushNamed(AppRoute.search, extra: searchQuery);
            return;
          }
          context.pushNamed(AppRoute.search);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding - 4,
          ),
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/Search.svg"),
              const Gap(defaultPadding / 2),
              Text(
                searchQuery != null ? searchQuery! : "Search products...",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
