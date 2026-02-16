import 'package:get_it/get_it.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/branches/data/repositories/branches_repository_impl.dart';
import '../../features/branches/domain/repositories/branches_repository.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../services/performance/performance_service.dart';

final sl = GetIt.instance;

void initRepositories() {
  PerformanceService.instance.startOperation('Repositories Init');

  sl.registerLazySingleton<BranchesRepository>(
    () => BranchesRepositoryImpl(
      remoteDatasource: sl(),
      localDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDatasource: sl(), localDatasource: sl()),
  );

   sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(remoteDatasource: sl()),
  );

  PerformanceService.instance.endOperation('Repositories Init');
}
