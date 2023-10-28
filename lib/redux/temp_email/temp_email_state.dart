import 'package:flutter/foundation.dart';
import 'package:tmail/models/temp_email.model.dart';

class TempEmailState {
  final List<TempEmail> emails;

  TempEmailState({
    required this.emails,
  });

  static List<TempEmail> _fromJsonToTempEmailList(List<dynamic> json) {
    try {
      List<TempEmail> emails = [];
      for (Map<String, dynamic> email in json) {
        emails.add(TempEmail.fromJson(email, 'Name from persistance'));
      }
      return emails;
    } catch (e) {
      if (kDebugMode) print("_fromJsonToTempEmailList: $e");
      return [];
    }
  }

  TempEmailState.fromJson(Map<String, dynamic> json) : emails = json.containsKey('emails') ? _fromJsonToTempEmailList(json['emails']) : [];

  List<Map<String, dynamic>> _tempEmailToJson() {
    List<Map<String, dynamic>> jsonTempEmails = [];
    for (var element in emails) {
      jsonTempEmails.add(element.toJson());
    }
    return jsonTempEmails;
  }

  Map<String, dynamic> toJson() => {
        'emails': _tempEmailToJson(),
      };

  TempEmailState.initialState() : emails = [];

  TempEmailState.updateEmails(List<TempEmail> newEmails) : emails = newEmails;
  TempEmailState.deleteAllEmails() : emails = [];
}
