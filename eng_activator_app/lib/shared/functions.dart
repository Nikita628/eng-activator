import 'package:eng_activator_app/widgets/dialogs/error_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Converter {
  static List<T> toList<T>(Map<String, dynamic> json, String prop) {
    var list = (json[prop] ?? []) as List;
    return list.map((e) => e as T).toList();
  }

  static List<T> convertToList<T>(Map<String, dynamic> json, String prop, T Function(dynamic) converter) {
    var list = (json[prop] ?? []) as List;
    return list.map((e) => converter(e)).toList();
  }
}

Future<void> showErrorDialog(String error, BuildContext ctx) async {
  await showDialog(
    context: ctx,
    builder: (_) => ErrorDialog(error: error),
  );
}
