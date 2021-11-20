import 'package:eng_activator_app/models/abusive_content_report.dart';
import 'package:eng_activator_app/services/api_clients/abusive_content_report_api_client.dart';
import 'package:eng_activator_app/shared/api_exception.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/functions.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:eng_activator_app/widgets/ui_elements/text_area.dart';
import 'package:flutter/material.dart';

class AbusiveContentReportScreen extends StatefulWidget {
  static const String screenUrl = "/abusive-content-report";

  const AbusiveContentReportScreen({Key? key}) : super(key: key);

  @override
  _AbusiveContentReportScreenState createState() => _AbusiveContentReportScreenState();
}

class _AbusiveContentReportScreenState extends State<AbusiveContentReportScreen> {
  final _abusiveContentReportApiClient = Injector.get<AbusiveContentReportApiClient>();
  final _appNavigator = Injector.get<AppNavigator>();
  var _buttonStatus = WidgetStatusEnum.Default;
  final _formKey = GlobalKey<FormState>();
  String _report = "";

  void _setButtonStatus(WidgetStatusEnum status) {
    if (mounted) {
      setState(() {
        _buttonStatus = status;
      });
    }
  }

  void _sendReport() async {
    var isValid = _formKey.currentState?.validate();

    if (isValid != true) {
      return;
    }

    _formKey.currentState?.save();

    _setButtonStatus(WidgetStatusEnum.Loading);

    try {
      var dto = AbusiveContentReport(report: _report);
      await _abusiveContentReportApiClient.create(dto, context);
      await showInfoDialog("Your report was submitted", context);
      _setButtonStatus(WidgetStatusEnum.Default);
      _appNavigator.replaceCurrentUrl(MainScreenWidget.screenUrl, context);
    } on ApiResponseException catch (e) {
      showErrorDialog(e.errorResponse.message, context);
      _setButtonStatus(WidgetStatusEnum.Default);
    } catch (e) {
      _setButtonStatus(WidgetStatusEnum.Default);
    }
  }

  void _onReportTextChange(String value) {
    _report = value;
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isAppBarShown: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 20),
        child: Column(
          children: [
            Text(
              "Abusive Content Report",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Container(
              child: Text("Here in Exenge users respect each other. If you've seen obusive reviews or assignemnts please report them to us. Provide review or assignment ID if you can, and provide name of the user who created the content."),
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 20),
            ),
            Form(
              key: _formKey,
              child: AppTextAreaWidget(
                validator: _validator,
                onSaved: (val) => _report = val ?? '',
                placeholder: 'Type your report here...',
                onChanged: _onReportTextChange,
                value: _report,
              ),
            ),
            RoundedButton(
              bgColor: const Color(AppColors.green),
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 30, left: 30),
              child: _buttonStatus == WidgetStatusEnum.Loading
                  ? AppSpinner()
                  : const Text(
                      'SUBMIT',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
              onPressed: _sendReport,
              disabled: _buttonStatus == WidgetStatusEnum.Loading,
            ),
          ],
        ),
      ),
    );
  }
}
