import 'package:tmail/redux/temp_email/reducers.dart';

import './app.state.dart';

AppState appReducer(
  AppState state,
  action,
) =>
    AppState(
      emailData: tempEmailsReducer(state.emailData, action),
    );
