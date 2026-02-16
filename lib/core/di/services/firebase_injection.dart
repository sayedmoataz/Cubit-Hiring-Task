import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../services/firebase/firestore/contracts/firestore_consumer.dart';
import '../../services/firebase/firestore/factory/firestore_factory.dart';
import '../../services/services.dart';
import '../injection_container.dart';

Future<void> initFirebase() async {
  PerformanceService.instance.startOperation('Firebase Services');

  // Register Firebase Crashlytics
  sl.registerSingleton<FirebaseCrashlytics>(FirebaseCrashlytics.instance);

  // Register Firebase Auth
  await initFirebaseAuth();

  // Register Firestore
  sl.registerLazySingleton<FirestoreConsumer>(
    () => FirestoreFactory.create(firestore: FirebaseFirestore.instance),
  );

  PerformanceService.instance.endOperation('Firebase Services');
}

Future<void> initFirebaseAuth() async {
  sl.registerLazySingleton<FirebaseAuthConsumer>(FirebaseAuthFactory.create);
}
