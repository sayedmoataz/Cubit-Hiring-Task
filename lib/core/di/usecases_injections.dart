import 'package:get_it/get_it.dart';

import '../../features/branches/domain/usecases/get_branch_by_id_usecase.dart';
import '../../features/branches/domain/usecases/get_branches_usecase.dart';
import '../../features/branches/domain/usecases/get_nearby_branches_usecase.dart';
import '../../features/branches/domain/usecases/search_branches_usecase.dart';
import '../services/performance/performance_service.dart';

final sl = GetIt.instance;

void initUseCases() {
  PerformanceService.instance.startOperation('UseCases Init');

  sl.registerLazySingleton(() => GetBranchesUseCase(sl()));
  sl.registerLazySingleton(() => SearchBranchesUseCase(sl()));
  sl.registerLazySingleton(() => GetNearbyBranchesUseCase(sl()));
  sl.registerLazySingleton(() => GetBranchByIdUseCase(sl()));

  PerformanceService.instance.endOperation('UseCases Init');
}
