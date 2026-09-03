import 'package:mt/features/home/domain/entities/category.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.icon, required super.title});
}

List<CategoryModel> demoCategories = [
  const CategoryModel(icon: "assets/icons/dress.svg", title: "Dress"),
  const CategoryModel(icon: "assets/icons/shirt.svg", title: "Shirt"),
  const CategoryModel(icon: "assets/icons/pants.svg", title: "Pants"),
  const CategoryModel(icon: "assets/icons/Tshirt.svg", title: "Tshirt"),
];
