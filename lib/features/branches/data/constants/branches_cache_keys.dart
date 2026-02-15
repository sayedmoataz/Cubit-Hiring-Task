class BranchesCacheKeys {
  BranchesCacheKeys._();
  static const String allBranches = 'all_branches';
  static const String lastSyncTime = 'branches_last_sync';
  static const Duration cacheValidDuration = Duration(hours: 24);
  static bool isCacheValid(DateTime? lastSync) {
    if (lastSync == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    return difference < cacheValidDuration;
  }
}
