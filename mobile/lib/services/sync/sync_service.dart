import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../data/local/local_storage_service.dart';

class SyncService extends ChangeNotifier {
  static final SyncService instance = SyncService._();
  SyncService._();

  SyncState _syncState = SyncState.synced;
  bool _isOfflineMode = false;
  int _pendingCount = 0;
  String _lastSyncMessage = 'All data synced';

  SyncState get syncState => _syncState;
  bool get isOfflineMode => _isOfflineMode;
  int get pendingCount => _pendingCount;
  String get lastSyncMessage => _lastSyncMessage;

  Future<void> init() async {
    _isOfflineMode = await LocalStorageService.instance.isOfflineModeEnabled();
    await refreshPendingCount();
  }

  Future<void> refreshPendingCount() async {
    final items = await LocalStorageService.instance.getPendingSyncItems();
    _pendingCount = items.length;
    if (_pendingCount > 0) {
      _syncState = SyncState.pendingSync;
      _lastSyncMessage = '$_pendingCount records waiting to sync';
    } else {
      _syncState = SyncState.synced;
      _lastSyncMessage = 'All data synced';
    }
    notifyListeners();
  }

  Future<void> toggleOfflineMode(bool enabled) async {
    _isOfflineMode = enabled;
    await LocalStorageService.instance.setOfflineMode(enabled);
    if (!_isOfflineMode && _pendingCount > 0) {
      await syncPendingItems();
    } else {
      notifyListeners();
    }
  }

  Future<void> syncPendingItems() async {
    if (_isOfflineMode) {
      _syncState = SyncState.pendingSync;
      _lastSyncMessage = 'Offline Mode. Actions queued.';
      notifyListeners();
      return;
    }

    final items = await LocalStorageService.instance.getPendingSyncItems();
    if (items.isEmpty) {
      _syncState = SyncState.synced;
      _lastSyncMessage = 'All data synced';
      notifyListeners();
      return;
    }

    _lastSyncMessage = 'Syncing $items.length items...';
    notifyListeners();

    try {
      final payload = {
        'items': items
            .map((item) => {
                  'client_id': item.id,
                  'entity_type': item.entityType,
                  'operation': item.operation,
                  'payload': item.payload,
                  'created_at': item.createdAt.toIso8601String(),
                })
            .toList(),
      };

      final response = await http
          .post(
            Uri.parse('${AppConstants.defaultApiBaseUrl}/sync/push'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        await LocalStorageService.instance.clearPendingSync();
        _pendingCount = 0;
        _syncState = SyncState.synced;
        _lastSyncMessage = 'All data synced';
      } else {
        _syncState = SyncState.syncFailed;
        _lastSyncMessage = 'Sync server error. Will retry.';
      }
    } catch (e) {
      // Local network unavailable; keep queued locally
      _syncState = SyncState.pendingSync;
      _lastSyncMessage = '$_pendingCount items waiting to sync (Offline)';
    }

    notifyListeners();
  }
}
