import 'package:get_it/get_it.dart';

import '../services/performance/performance_service.dart';

final sl = GetIt.instance;

void initDataSources() {
  PerformanceService.instance.startOperation('DataSources Init');

  PerformanceService.instance.endOperation('DataSources Init');
}
