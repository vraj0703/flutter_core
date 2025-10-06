import 'package:flutter/foundation.dart';

@immutable
class MemberStatus {
  final Map<String, dynamic> _statusConfigs;

  const MemberStatus._(this._statusConfigs);

  factory MemberStatus.fromJson(Map<String, dynamic> json) {
    // Default status values, similar to the original enum
    final defaults = {
      'prospect': 'PROSPECT',
      'registration': 'REGISTRATION',
      'pendingActive': 'PENDING_ACTIVE',
      'discharged': 'DISCHARGED',
      'active': 'ACTIVE',
      'onHold': 'ON_HOLD',
      'inActive': 'INACTIVE',
      'unknown': 'UNKNOWN',
    };

    final statusesRaw = json['member_statuses'];
    final config = statusesRaw != null
        ? {...defaults, ...Map<String, dynamic>.from(statusesRaw as Map)}
        : defaults;

    return MemberStatus._(config);
  }

  // --- Getters for default statuses ---
  String get prospect => status('prospect');

  String get registration => status('registration');

  String get pendingActive => status('pendingActive');

  String get discharged => status('discharged');

  String get active => status('active');

  String get onHold => status('onHold');

  String get inActive => status('inActive');

  String get unknown => status('unknown');

  /// Optionally get any status by its key.
  ///
  /// This method allows for accessing both default and custom-defined statuses
  /// from the JSON configuration. It will throw an exception if the key
  /// is not found in the configuration.
  String status(String key) {
    final value = _statusConfigs[key];
    if (value is String) return value;
    throw Exception('MemberStatus key "$key" not found or is not a String');
  }

  /// Returns a list of all available status values.
  List<String> get allStatuses => _statusConfigs.values.cast<String>().toList();

  /// Returns a map of all configured statuses.
  Map<String, String> get allStatusEntries =>
      _statusConfigs.cast<String, String>();
}
