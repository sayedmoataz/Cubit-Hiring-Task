# Flutter Technical Assessment: Secure Banking Branch Locator

This repository contains the technical assessment for Flutter Developer position. The project is a secure, high-performance banking application focused on security and large-scale data processing.

## Project Overview
A branch locator app that handles **10,000+ records** with an "Offline-First" strategy, ensuring banking-grade security and a smooth 60 FPS user experience.

---

## Technical Rationale (Executive Summary)

### 1. Data & Performance
* **High-Speed Storage:** Used **Hive (NoSQL)** for sub-millisecond read/write performance, which is essential for handling 10k records efficiently compared to traditional SQLite.
* **Concurrency:** CPU-intensive tasks (JSON parsing & distance filtering) are offloaded to a **Background Isolate** (via `compute`). This ensures the Main UI thread remains non-blocking and perfectly smooth.


### 2. Security Justification
* **Encryption at Rest:** The local database is fully encrypted using **AES-256**.
* **Hardware-Backed Key Management:** Encryption keys are stored in the device's secure hardware (**Android KeyStore / iOS Keychain**) using `flutter_secure_storage`. This ensures keys are inaccessible even on rooted devices.


### 3. Reliability & Access
* **Advanced Networking:** Implemented **Dio with Interceptors** to handle automatic retries, logging, and timeouts for stable connectivity.
* **Biometric Lock:** Integrated **FaceID/TouchID** via `local_auth` as a mandatory security gate for dashboard access.

---

## Key Implementation Details
- **Architecture:** Clean Architecture (Data, Domain, Presentation).
- **State Management:** BLoC / Cubit.
- **Dependency Injection:** GetIt.
- **Maps:** Open Street Map with real-time "Nearest 50" location filtering.

---

## ⚙️ How to Run
1. `flutter pub get`
2. `flutter pub run build_runner build --delete-conflicting-outputs`
3. `flutter run`