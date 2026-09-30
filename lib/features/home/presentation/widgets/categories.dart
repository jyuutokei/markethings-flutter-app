import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/features/home/domain/entities/category_entity.dart';
import 'package:mt/features/home/domain/usecases/get_categories.dart';
import 'package:mt/injection_container.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryEntity>>(
      future: sl<GetCategories>().call(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SpinKitWave(color: Colors.white));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final categories = snapshot.data ?? [];

        return SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return CategoryCard(
                name: category.name,
                icon: category.imageUrl,
                press: () {},
              );
            },
            separatorBuilder: (context, index) => const Gap(defaultPadding),
          ),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.name,
    required this.icon,
    required this.press,
  });

  final String name;
  final String icon;
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
            SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.network(
                icon,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                placeholderBuilder: (context) => const Center(
                  child: SpinKitDoubleBounce(size: 30, color: Colors.white),
                ),
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image_outlined, size: 35),
              ),
            ),
            const Gap(defaultPadding / 4),
            Text(
              "${name.split('&')[0]} &\n${name.split('&')[1]}",
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
