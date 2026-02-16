## Architecture Decision Record (ADR)

### 1. Local Storage: Hive (NoSQL)

* **Decision:** Using Hive instead of SQLite or SharedPreferences.

* **Rationale:** 
1. **Performance:** Processing 10k records requires a high-performance database. Hive's NoSQL nature allows for sub-millisecond read/write operations by keeping data in memory-mapped files.

2. **Security:** Hive provides native support for AES-256 encryption, which simplifies the implementation of "at-rest" security compared to SQLCipher.

### 2. Encryption Strategy & Key Management

**Decision:** AES-256 Encryption with Hardware-backed Key Storage.

**Rationale:** * We generate a 32-byte secure key using `Hive.generateSecureKey()`.

* **Key Storage:** The key is NEVER stored in plain text. It is persisted using `flutter_secure_storage` which utilizes **Android KeyStore** and **iOS Keychain**. This ensures the master key is protected within a hardware-isolated environment (TEE), making it unreadable even on rooted devices.

### 3. Networking: Dio over HTTP

**Decision:** Using Dio package for all remote data fetching.

**Rationale:** * **Interceptors:** Centralized logic for adding Interceptors and logging (PrettyDioLogger).

* **Reliability:** Built-in support for "Retry" logic and "Timeouts" which is critical for a banking app to handle unstable network conditions gracefully.
* **Flexibility:** Better handling of `FormData` and `Response` parsing.

### 4. Concurrency: Background Processing

**Decision:** Offloading JSON parsing and distance calculations to a separate Isolate.

**Rationale:** * Parsing 10,000 JSON objects is CPU-intensive. By using `compute()`, we move this workload to a background thread. This keeps the Main UI thread free, ensuring a smooth 60 FPS experience and preventing UI "freezing" during data synchronization.

### 5. Security: Biometric Access Lock

**Decision:** Mandatory Biometric verification (`local_auth`) on App Startup.

**Rationale:** * To prevent unauthorized access if the device is unlocked and handed to another person. The biometric layer acts as a local security gate before accessing sensitive financial data on the Dashboard.
