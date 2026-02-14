import '../../config/app_config.dart';
import '../../services/services.dart';
import '../injection_container.dart';

Future<void> initBiometric() async {
  PerformanceService.instance.startOperation('Biometric Init');
  sl.registerLazySingleton<BiometricConsumer>(
    () => BiometricFactory.create(enableLogging: AppConfig.enableLogging),
  );
  PerformanceService.instance.endOperation('Biometric Init');
}
