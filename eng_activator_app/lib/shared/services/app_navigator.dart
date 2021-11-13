import 'package:eng_activator_app/shared/state/current_url_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppNavigator {
  Future<void> replaceCurrentUrl(String newUrl, BuildContext context, {Object? args}) async {
    Provider.of<CurrentUrlProvider>(context, listen: false).setCurrentUrlAndNotifyListeners(newUrl);
    await Navigator.of(context).pushReplacementNamed(newUrl, arguments: args);
  }
}