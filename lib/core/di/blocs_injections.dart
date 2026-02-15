import 'package:get_it/get_it.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/branches/presentation/bloc/branches_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../services/biometric/utils/biometric_preferences.dart';
import '../services/performance/performance_service.dart';

final sl = GetIt.instance;

void initBlocs() {
  PerformanceService.instance.startOperation('BLoCs Init');

  // Auth
  sl.registerFactory(
    () => AuthBloc(
      repository: sl(),
      biometricConsumer: sl(),
      biometricPreferences: BiometricPreferences(sl()),
      navigationService: sl(),
      networkInfo: sl(),
    ),
  );

  // Dashboard
  sl.registerFactory(DashboardBloc.new);

  // Branches
  sl.registerFactory(
    () =>
        BranchesBloc(getBranchesUseCase: sl(), getNearbyBranchesUseCase: sl()),
  );

  PerformanceService.instance.endOperation('BLoCs Init');
}
