// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'platformUrl', 'firstName', 'timeZoneId'],
  );
  return UserInfo(
    id: (json['id'] as num).toInt(),
    platformUrl: json['platformUrl'] as String,
    firstName: json['firstName'] as String,
    enrollmentDate: UserInfo._toDate(json['enrollmentDate'] as String?),
    activationDate: UserInfo._toDate(json['activationDate'] as String?),
    timezone: json['timeZoneId'] as String,
    lastName: json['lastName'] as String? ?? '',
    gender: json['gender'] as String? ?? '',
    status: json['status'] as String?,
    preferredName: json['preferredName'] as String?,
    mobileNumber: json['mobileNumber'] as String?,
    email: json['login'] as String?,
    dateOfBirth: json['dateOfBirth'] as String?,
  );
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
  'id': instance.id,
  'platformUrl': instance.platformUrl,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'preferredName': instance.preferredName,
  'enrollmentDate': instance.enrollmentDate?.toIso8601String(),
  'activationDate': instance.activationDate?.toIso8601String(),
  'timeZoneId': instance.timezone,
  'gender': instance.gender,
  'status': instance.status,
  'mobileNumber': instance.mobileNumber,
  'login': instance.email,
  'dateOfBirth': instance.dateOfBirth,
};
