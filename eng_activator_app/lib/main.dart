import 'dart:io';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/shared/state/current_url_provider.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:eng_activator_app/widgets/home_widget.dart';
import 'package:eng_activator_app/widgets/screens/abusive_content_report_screen.dart';
import 'package:eng_activator_app/widgets/screens/activity/activity_for_review.dart';
import 'package:eng_activator_app/widgets/screens/activity/picture_activity_screen.dart';
import 'package:eng_activator_app/widgets/screens/activity/question_activity_screen.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/activity_response_list.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/picture_activity_response.dart';
import 'package:eng_activator_app/widgets/screens/auth/login.dart';
import 'package:eng_activator_app/widgets/screens/auth/reset_password_screen.dart';
import 'package:eng_activator_app/widgets/screens/auth/signup.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/question_activity_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const currentAppEnv = AppEnvironment.Local;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(EnglishActivatorApp());

  AppConstants.currentAppEnvironment = currentAppEnv;

  if (currentAppEnv == AppEnvironment.Local) {
    HttpOverrides.global = MyHttpOverrides();
  }
}

class EnglishActivatorApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ActivityProvider>(create: (_) => ActivityProvider()),
        ChangeNotifierProvider<CurrentUrlProvider>(create: (_) => CurrentUrlProvider()),
        ChangeNotifierProvider<ActivityResponseProvider>(create: (_) => ActivityResponseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Varela'),
        home: HomeWidget(),
        routes: {
          MainScreenWidget.screenUrl: (_) => MainScreenWidget(),
          ActivityForReview.screenUrl: (_) => ActivityForReview(),
          LoginScreenWidget.screenUrl: (_) => LoginScreenWidget(),
          SignupScreenWidget.screenUrl: (_) => SignupScreenWidget(),
          PictureActivityResponseWidget.screenUrl: (_) => PictureActivityResponseWidget(),
          QuestionActivityResponseWidget.screenUrl: (_) => QuestionActivityResponseWidget(),
          ActivityResponseListWidget.screenUrl: (_) => ActivityResponseListWidget(),
          QuestionActivityScreen.screenUrl: (_) => QuestionActivityScreen(),
          PictureActivityScreen.screenUrl: (_) => PictureActivityScreen(),
          ResetPasswordScreenWidget.screenUrl: (_) => ResetPasswordScreenWidget(),
          AbusiveContentReportScreen.screenUrl: (_) => AbusiveContentReportScreen(),
        },
      ),
    );
  }
}
