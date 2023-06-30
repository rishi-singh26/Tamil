import 'package:tmail/models/temp_email.model.dart';
import 'package:tmail/redux/temp_email/temp_email_action.dart';
import 'package:tmail/redux/temp_email/temp_email_state.dart';
import 'package:redux/redux.dart';

Reducer<TempEmailState> tempEmailsReducer = combineReducers([
  addNewTempEmailReducer,
  deleteTempEmailReducer,
  clearAllTempEmailsReducer,
]);

TempEmailState addNewTempEmailReducer(TempEmailState prevState, dynamic action) {
  if (action is AddTempEmailAction) {
    List<TempEmail> newEmails = [...prevState.emails];
    newEmails.add(action.newEmail);
    return TempEmailState.updateEmails(newEmails);
  }
  return prevState;
}

TempEmailState deleteTempEmailReducer(TempEmailState prevState, dynamic action) {
  if (action is RemoveOneTempEmail) {
    List<TempEmail> newEmails = [...prevState.emails];
    newEmails.remove(action.removedEmail);
    return TempEmailState.updateEmails(newEmails);
  }
  return prevState;
}

TempEmailState clearAllTempEmailsReducer(TempEmailState prevState, dynamic action) {
  if (action is RemoveAllTempEmail) {
    return TempEmailState.deleteAllEmails();
  }
  return prevState;
}
