import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/branches/data/datasources/branches_local_datasource.dart';
import '../../features/branches/data/datasources/branches_remote_datasource.dart';
import '../services/performance/performance_service.dart';

final sl = GetIt.instance;

void initDataSources() {
  PerformanceService.instance.startOperation('DataSources Init');

  // Auth
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(firebaseAuthConsumer: sl()),
  );
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(hiveConsumer: sl()),
  );

  // Branches
  sl.registerLazySingleton<BranchesRemoteDatasource>(
    () => BranchesRemoteDatasourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<BranchesLocalDatasource>(
    () => BranchesLocalDatasourceImpl(hiveConsumer: sl()),
  );

  PerformanceService.instance.endOperation('DataSources Init');
}
