import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show DefaultMaterialLocalizations;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tmail/pages/home/home.dart';
import 'package:tmail/redux/combined_store.dart';
import 'package:tmail/redux/store/app.state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(store: await AppStore.getAppStore()));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return const CupertinoApp(
            title: 'Flutter Demo',
            theme: CupertinoThemeData(),
            home: MyHomePage(title: 'Temp Mail'),
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
