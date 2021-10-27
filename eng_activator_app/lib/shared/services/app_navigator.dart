import 'package:eng_activator_app/shared/state/current_url_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppNavigator {
  void replaceCurrentUrl(String newUrl, BuildContext context){
    Provider.of<CurrentUrlProvider>(context, listen: false).setCurrentUrl(newUrl);
    Navigator.of(context).pushReplacementNamed(newUrl);
  }

  void pushOnTopCurrentUrl(String newUrl, BuildContext context, {Object? args}){
    Provider.of<CurrentUrlProvider>(context, listen: false).setCurrentUrl(newUrl);
    Navigator.of(context).pushNamed(newUrl, arguments: args);
  }

  void popToUrl(String newUrl, BuildContext context){
    Provider.of<CurrentUrlProvider>(context, listen: false).setCurrentUrl(newUrl);
    Navigator.of(context).pop();
  }
}