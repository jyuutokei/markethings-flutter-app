import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/features/home/data/models/category.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: demoCategories.length,
        itemBuilder: (context, index) => CategoryCard(
          icon: demoCategories[index].icon,
          title: demoCategories[index].title,
          press: () {},
        ),
        separatorBuilder: (context, index) => const Gap(defaultPadding),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.press,
  });

  final String icon, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: defaultPadding / 2,
          horizontal: defaultPadding / 4,
        ),
        child: Column(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(height: defaultPadding / 2),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}
