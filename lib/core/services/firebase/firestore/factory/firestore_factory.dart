import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../config/app_config.dart';
import '../contracts/firestore_consumer.dart';
import '../implementation/firestore_consumer_impl.dart';

class FirestoreFactory {
  FirestoreFactory._();

  static FirestoreConsumer create({
    required FirebaseFirestore firestore,
    bool enableLogging = AppConfig.enableLogging,
  }) {
    return FirestoreConsumerImpl(
      firestore: firestore,
      enableLogging: enableLogging,
    );
  }
}
