import 'dart:io';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/shared/state/current_url_provider.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:eng_activator_app/widgets/home_widget.dart';
import 'package:eng_activator_app/widgets/screens/activity/activity_for_review.dart';
import 'package:eng_activator_app/widgets/screens/activity/current_activity.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/activity_response_list.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/picture_activity_response.dart';
import 'package:eng_activator_app/widgets/screens/auth/login.dart';
import 'package:eng_activator_app/widgets/screens/auth/signup.dart';
import 'package:eng_activator_app/widgets/screens/help.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/question_activity_response.dart';
import 'package:eng_activator_app/widgets/ui_elements/auth_provider_consumer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  // TODO remove in production
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(EnglishActivatorApp());

  HttpOverrides.global = MyHttpOverrides();
}

class EnglishActivatorApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ActivityProvider>(create: (_) => ActivityProvider()),
        ChangeNotifierProvider<CurrentUrlProvider>(create: (_) => CurrentUrlProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Varela'),
        home: HomeWidget(),
        routes: {
          MainScreenWidget.screenUrl: (_) => AuthGuard(child: MainScreenWidget()),
          ActivityResponseListWidget.screenUrl: (_) => AuthGuard(child: ActivityResponseListWidget()),
          // PictureActivityResponseWidget.screenUrl: (_) => AuthGuard(child: PictureActivityResponseWidget()),
          // QuestionActivityResponseWidget.screenUrl: (_) => AuthGuard(child: QuestionActivityResponseWidget()),
          ActivityForReview.screenUrl: (_) => AuthGuard(child: ActivityForReview()),
          AppHelpWidget.screenUrl: (_) => AuthGuard(child: AppHelpWidget()),
          CurrentActivityWidget.screenUrl: (_) => AuthGuard(child: CurrentActivityWidget()),
          LoginScreenWidget.screenUrl: (_) => LoginScreenWidget(),
          SignupScreenWidget.screenUrl: (_) => SignupScreenWidget(),
        },
        onGenerateRoute: (RouteSettings settings) {
          var routes = <String, WidgetBuilder>{
            PictureActivityResponseWidget.screenUrl: (ctx) =>
                PictureActivityResponseWidget(pictureActivityResponseId: settings.arguments as int),
            QuestionActivityResponseWidget.screenUrl: (ctx) =>
                QuestionActivityResponseWidget(questionActivityResponseId: settings.arguments as int)
          };
          WidgetBuilder builder = routes[settings.name] as WidgetBuilder;
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
      ),
    );
  }
}
