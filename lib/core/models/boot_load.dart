import 'package:flutter_core/core/models/user_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'boot_load.g.dart';

/// the [BootLoad] is the minimum initial arguments require to run any
/// route in member app v4.
///
/// If member app v4 is initialised from the native,
/// flutter ask [BootLoad] from native and wait for it.
/// refer [AppBloc._configureApp] function
///
/// If member app v4 is initialised for debugging purpose,
/// Sample [BootLoad] are available at [CredentialsForDebug]
@JsonSerializable()
class BootLoad {
  @JsonKey(required: true)
  final UserInfo userInfo;

  @JsonKey(required: true)
  final Map<String, dynamic> featureFlags;

  @JsonKey(required: false)
  final String? debugBasicAuth;

  @JsonKey(required: false)
  final String? debugJwt;

  @JsonKey(required: false)
  final String? languageCode;

  @JsonKey(required: false)
  final String? countryCode;

  BootLoad({
    required this.userInfo,
    required this.featureFlags,
    this.debugBasicAuth,
    this.debugJwt,
    this.languageCode,
    this.countryCode,
  });

  factory BootLoad.fromJson(Map<String, dynamic> json) {
    return _$BootLoadFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BootLoadToJson(this);

  @override
  String toString() =>
      "Boot load :: $userInfo,\n feature flag : $featureFlags,\n debugBasicAuth :$debugBasicAuth";

  factory BootLoad.sample() {
    return BootLoad(
      userInfo: UserInfo.sample(),
      featureFlags: {
        "is_card_re_issuance_enabled": true,
        "is_biometric_login_enabled": false,
      },
      debugBasicAuth: null,
      debugJwt: null,
    );
  }
}
