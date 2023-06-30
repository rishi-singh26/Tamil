import 'package:tmail/models/temp_email.model.dart';

abstract class TempEmailAction {}

class AddTempEmailAction extends TempEmailAction {
  final TempEmail newEmail;
  AddTempEmailAction({
    required this.newEmail,
  });
}

class RemoveOneTempEmail extends TempEmailAction {
  final TempEmail removedEmail;
  RemoveOneTempEmail({
    required this.removedEmail,
  });
}

class RemoveAllTempEmail extends TempEmailAction {}
