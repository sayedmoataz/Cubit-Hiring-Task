import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../services/services.dart';
import '../injection_container.dart';

Future<void> initFirebase() async {
  PerformanceService.instance.startOperation('Firebase Services');

  // Register Firebase Crashlytics
  sl.registerSingleton<FirebaseCrashlytics>(FirebaseCrashlytics.instance);

  // Register Firebase Auth
  await initFirebaseAuth();

  PerformanceService.instance.endOperation('Firebase Services');
}

Future<void> initFirebaseAuth() async {
  sl.registerLazySingleton<FirebaseAuthConsumer>(FirebaseAuthFactory.create);
}
