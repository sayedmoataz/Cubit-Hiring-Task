import 'package:get_it/get_it.dart';

import '../../features/branches/data/repositories/branches_repository_impl.dart';
import '../../features/branches/domain/repositories/branches_repository.dart';
import '../services/performance/performance_service.dart';

final sl = GetIt.instance;

void initRepositories() {
  PerformanceService.instance.startOperation('Repositories Init');

  sl.registerLazySingleton<BranchesRepository>(
    () => BranchesRepositoryImpl(apiConsumer: sl(), hiveConsumer: sl()),
  );

  PerformanceService.instance.endOperation('Repositories Init');
}
