import 'package:flutter_core/domain/enums/member_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String platformUrl;

  @JsonKey(required: true)
  final String firstName;

  @JsonKey(defaultValue: '')
  final String lastName;

  @JsonKey(includeIfNull: true)
  final String? preferredName;

  @JsonKey(fromJson: _toDate)
  final DateTime? enrollmentDate;

  @JsonKey(fromJson: _toDate)
  final DateTime? activationDate;

  @JsonKey(required: true, name: 'timeZoneId')
  final String timezone;

  @JsonKey(defaultValue: '')
  final String gender;

  @JsonKey(defaultValue: MemberStatus.unknown)
  final MemberStatus? status;

  @JsonKey(defaultValue: null)
  final String? mobileNumber;

  @JsonKey(name: "login")
  final String? email;

  @JsonKey(required: false)
  String? dateOfBirth;

  static DateTime? _toDate(String? date) =>
      date != null ? DateTime.tryParse(date) : null;

  UserInfo({
    required this.id,
    required this.platformUrl,
    required this.firstName,
    required this.enrollmentDate,
    required this.activationDate,
    required this.timezone,
    required this.lastName,
    required this.gender,
    this.status,
    this.preferredName,
    this.mobileNumber,
    this.email,
    this.dateOfBirth,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  @override
  String toString() {
    return 'UserInfo{id: $id,\n platformUrl: $platformUrl,'
        '\n lastName: $lastName,\n preferredName: $preferredName,'
        '\n timezone: $timezone,\n gender: $gender}';
  }
}
