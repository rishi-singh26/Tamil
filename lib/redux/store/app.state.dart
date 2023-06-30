// import 'package:farmers/redux/auth/auth_state.dart';

import 'package:tmail/redux/temp_email/temp_email_state.dart';

class AppState {
  final TempEmailState emailData;

  AppState({
    required this.emailData,
  });

  factory AppState.initial() => AppState(
        emailData: TempEmailState.initialState(),
      );

  @override
  bool operator ==(other) => identical(this, other) || other is AppState && runtimeType == other.runtimeType;

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return 'AppState:{\n\temailData: ${emailData.toJson()}\n}';
  }

  static AppState fromJson(dynamic json) {
    return AppState(
      emailData: json == null || json['emailData'] == null ? TempEmailState.initialState() : TempEmailState.fromJson(json['emailData']),
    );
  }

  Map<String, dynamic> toJson() => {
        'emailData': emailData.toJson(),
      };
}
