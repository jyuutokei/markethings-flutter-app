import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/features/home/domain/entities/category_entity.dart';
import 'package:mt/features/home/domain/usecases/get_categories.dart';
import 'package:mt/injection_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late Future<List<CategoryEntity>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = sl<GetCategories>().call();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryEntity>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        final loading = snapshot.connectionState == ConnectionState.waiting;

        final categories = loading
            ? List.generate(
                4,
                (index) => CategoryEntity(
                  id: -index - 1,
                  name: 'Cute & Funny',
                  slug: '',
                  imageUrl: '',
                ),
              )
            : snapshot.data ?? const <CategoryEntity>[];

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return Skeletonizer(
          enabled: loading,
          ignorePointers: true,
          child: SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return CategoryCard(
                  name: category.name,
                  icon: category.imageUrl,
                  press: () {
                    context.pushNamed(
                      AppRoute.products,
                      extra: {'categoryId': category.id},
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => const Gap(defaultPadding),
            ),
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
            Skeleton.replace(
              width: 40,
              height: 40,
              child: SvgPicture.network(
                icon,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
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
