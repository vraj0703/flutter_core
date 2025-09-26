import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: "status")
enum MemberStatus {
  @JsonValue('PROSPECT')
  prospect,
  @JsonValue('REGISTRATION')
  registration,
  @JsonValue('PENDING_ACTIVE')
  pendingActive,
  @JsonValue('DISCHARGED')
  discharged,
  @JsonValue('ACTIVE')
  active,
  @JsonValue('ON_HOLD')
  onHold,
  @JsonValue('INACTIVE')
  inActive,
  @JsonValue('unknown')
  unknown;

  String get name => toString().split('.').last;
}

extension MemberStatusExtension on MemberStatus {
  String get status {
    switch (this) {
      case MemberStatus.prospect:
        return "PROSPECT";
      case MemberStatus.registration:
        return "REGISTRATION";
      case MemberStatus.pendingActive:
        return "PENDING_ACTIVE";
      case MemberStatus.discharged:
        return "DISCHARGED";
      case MemberStatus.active:
        return "ACTIVE";
      case MemberStatus.onHold:
        return "ON_HOLD";
      case MemberStatus.inActive:
        return "INACTIVE";
      case MemberStatus.unknown:
        return "unknown";
    }
  }
}