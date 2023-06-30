import 'dart:math';

import 'package:mailtm_client/mailtm_client.dart';

// import 'package:tmail/services/mailtm/mailtm_client.dart';

class EmailService {
  static String generateRandomAddtess([int length = 8]) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  static Future<List<TMDomain>> getAvailableDomains() async {
    try {
      return await TMDomain.domains;
    } catch (e) {
      return [];
    }
  }

  static List<TMAccount> getAccounts() {
    try {
      return MailTm.accounts;
    } catch (e) {
      return [];
    }
  }
}
