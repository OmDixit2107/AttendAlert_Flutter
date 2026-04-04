import 'package:attendalert/core/network/dio_client.dart';
import 'package:attendalert/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:attendalert/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:attendalert/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:attendalert/features/auth/domain/repositories/auth_repository.dart';
import 'package:attendalert/features/auth/domain/usecases/login_usecase.dart';
import 'package:attendalert/features/auth/domain/usecases/signup_usecase.dart';
import 'package:get_it/get_it.dart';

//service locator
final sl = GetIt.instance;

void configureDependicies() {
  //core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  //datasources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // 3. REPOSITORIES
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl()),
  );

  // ---------------------------------------------------------------------------
  // 4. USE CASES (DOMAIN)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignupUseCase(authRepository: sl()));
}
