// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boot_load.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BootLoad _$BootLoadFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['userInfo', 'featureFlags']);
  return BootLoad(
    userInfo: UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
    featureFlags: json['featureFlags'] as Map<String, dynamic>,
    config: json['config'] as Map<String, dynamic>?,
    debugBasicAuth: json['debugBasicAuth'] as String?,
    debugJwt: json['debugJwt'] as String?,
    languageCode: json['languageCode'] as String?,
    countryCode: json['countryCode'] as String?,
  );
}

Map<String, dynamic> _$BootLoadToJson(BootLoad instance) => <String, dynamic>{
  'userInfo': instance.userInfo,
  'featureFlags': instance.featureFlags,
  'config': instance.config,
  'debugBasicAuth': instance.debugBasicAuth,
  'debugJwt': instance.debugJwt,
  'languageCode': instance.languageCode,
  'countryCode': instance.countryCode,
};
