import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:get_it/get_it.dart';
import 'package:mt/features/auth/data/repository/auth_repo_impl.dart';
import 'package:mt/features/auth/domain/repository/auth_repo.dart';
import 'package:mt/features/home/data/datasources/cart_item_remote_data_source.dart';
import 'package:mt/features/home/data/datasources/category_remote_data_source.dart';
import 'package:mt/features/home/data/datasources/product_card_remote_data_source.dart';
import 'package:mt/features/home/data/datasources/product_details_remote_data_source.dart';
import 'package:mt/features/home/data/repositories/cart_item_repository_impl.dart';
import 'package:mt/features/home/data/repositories/category_repository_impl.dart';
import 'package:mt/features/home/data/repositories/product_card_repository_impl.dart';
import 'package:mt/features/home/data/repositories/product_details_repository_impl.dart';
import 'package:mt/features/home/domain/repositories/cart_item_repository.dart';
import 'package:mt/features/home/domain/repositories/category_repository.dart';
import 'package:mt/features/home/domain/repositories/product_card_repository.dart';
import 'package:mt/features/home/domain/repositories/product_details_repository.dart';
import 'package:mt/features/home/domain/usecases/add_cart_item.dart';
import 'package:mt/features/home/domain/usecases/get_cart_item_details.dart';
import 'package:mt/features/home/domain/usecases/get_categories.dart';
import 'package:mt/features/home/domain/usecases/get_product_card_details.dart';
import 'package:mt/features/home/domain/usecases/get_product_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:mt/config/env/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

void setupLocator() async {
  // supabase
  await Supabase.initialize(url: Env.spbUrl, publishableKey: Env.spbPbkey);
  sl.registerSingleton<SupabaseClient>(Supabase.instance.client);
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl<SupabaseClient>()));

  // talker
  sl.registerSingleton<Talker>(TalkerFlutter.init());
  sl.registerSingleton<TalkerRouteObserver>(TalkerRouteObserver(Talker()));
  sl.registerSingleton<TalkerLogger>(TalkerLogger());

  // shared preference
  final sharedPreference = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreference);

  // debouncer
  sl.registerLazySingleton<Debouncer>(() => Debouncer());

  // datasource/repo/usecase
  // code order is necessary: datasource -> repo -> usecase

  // datasources
  sl.registerLazySingleton<ProductCardRemoteDataSource>(
    () => ProductCardRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<ProductDetailsRemoteDataSource>(
    () => ProductDetailsRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<CartItemRemoteDataSource>(
    () => CartItemRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  // repositories
  sl.registerLazySingleton<ProductCardRepository>(
    () => ProductCardRepositoryImpl(sl<ProductCardRemoteDataSource>()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl<CategoryRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProductDetailsRepository>(
    () => ProductDetailsRepositoryImpl(sl<ProductDetailsRemoteDataSource>()),
  );
  sl.registerLazySingleton<CartItemRepository>(
    () => CartItemRepositoryImpl(sl<CartItemRemoteDataSource>()),
  );

  // usecases
  sl.registerLazySingleton<GetProductCardDetails>(
    () => GetProductCardDetails(sl<ProductCardRepository>()),
  );
  sl.registerLazySingleton<GetCategories>(
    () => GetCategories(sl<CategoryRepository>()),
  );
  sl.registerLazySingleton<GetProductDetails>(
    () => GetProductDetails(sl<ProductDetailsRepository>()),
  );
  sl.registerLazySingleton<AddCartItem>(
    () => AddCartItem(sl<CartItemRepository>()),
  );
  sl.registerLazySingleton<GetCartItemDetails>(
    () => GetCartItemDetails(sl<CartItemRepository>()),
  );
}
