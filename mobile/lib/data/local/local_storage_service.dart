import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

enum SyncState { synced, pendingSync, syncFailed }

class PendingSyncItem {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  String syncStatus;
  int retryCount;

  PendingSyncItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    this.syncStatus = 'PENDING',
    this.retryCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'operation': operation,
      'payload': payload,
      'created_at': createdAt.toIso8601String(),
      'sync_status': syncStatus,
      'retry_count': retryCount,
    };
  }

  factory PendingSyncItem.fromMap(Map<String, dynamic> map) {
    return PendingSyncItem(
      id: map['id'] ?? '',
      entityType: map['entity_type'] ?? '',
      entityId: map['entity_id'] ?? '',
      operation: map['operation'] ?? '',
      payload: Map<String, dynamic>.from(map['payload'] ?? {}),
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      syncStatus: map['sync_status'] ?? 'PENDING',
      retryCount: map['retry_count'] ?? 0,
    );
  }
}

class LocalStorageService {
  static const String _pendingSyncKey = 'fasalrakshak_pending_sync';
  static const String _diagnosesKey = 'fasalrakshak_cached_diagnoses';
  static const String _farmKey = 'fasalrakshak_cached_farm';
  static const String _offlineToggleKey = 'fasalrakshak_offline_mode';

  static final LocalStorageService instance = LocalStorageService._();
  LocalStorageService._();

  // Offline Mode Toggle (For hackathon presentation simulation)
  Future<bool> isOfflineModeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_offlineToggleKey) ?? false;
  }

  Future<void> setOfflineMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_offlineToggleKey, enabled);
  }

  // --- PENDING SYNC QUEUE ---
  Future<List<PendingSyncItem>> getPendingSyncItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_pendingSyncKey) ?? [];
    return raw
        .map((str) => PendingSyncItem.fromMap(jsonDecode(str)))
        .toList();
  }

  Future<void> addPendingSyncItem({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getPendingSyncItems();
    final newItem = PendingSyncItem(
      id: const Uuid().v4(),
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      payload: payload,
      createdAt: DateTime.now(),
    );
    items.add(newItem);
    await prefs.setStringList(
      _pendingSyncKey,
      items.map((i) => jsonEncode(i.toMap())).toList(),
    );
  }

  Future<void> clearPendingSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingSyncKey);
  }

  // --- CACHED DIAGNOSES ---
  Future<List<Map<String, dynamic>>> getCachedDiagnoses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_diagnosesKey) ?? [];
    return raw
        .map((str) => Map<String, dynamic>.from(jsonDecode(str)))
        .toList();
  }

  Future<void> saveDiagnosisLocally(Map<String, dynamic> diagnosis) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getCachedDiagnoses();
    list.insert(0, diagnosis);
    await prefs.setStringList(
      _diagnosesKey,
      list.map((d) => jsonEncode(d)).toList(),
    );
  }

  // --- CACHED FARM PROFILE ---
  Future<Map<String, dynamic>?> getCachedFarm() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_farmKey);
    if (raw != null) {
      return Map<String, dynamic>.from(jsonDecode(raw));
    }
    return null;
  }

  Future<void> cacheFarm(Map<String, dynamic> farm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_farmKey, jsonEncode(farm));
  }
}
