import 'package:eng_activator_app/models/auth/signup_data.dart';
import 'package:eng_activator_app/services/api_clients/auth_api_client.dart';
import 'package:eng_activator_app/shared/api_exception.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/services/auth/auth_validator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/dialogs/confirm_email_dialog.dart';
import 'package:eng_activator_app/widgets/dialogs/error_dialog.dart';
import 'package:eng_activator_app/widgets/screens/auth/input_field.dart';
import 'package:eng_activator_app/widgets/screens/auth/login.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_logo.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:eng_activator_app/widgets/ui_elements/exit_warning_on_pop.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:flutter/material.dart';

class SignupScreenWidget extends StatefulWidget {
  static const screenUrl = '/signup-screen-widget';

  const SignupScreenWidget({Key? key}) : super(key: key);

  @override
  _SignupScreenWidgetState createState() => _SignupScreenWidgetState();
}

class _SignupScreenWidgetState extends State<SignupScreenWidget> {
  final AppNavigator _appNavigator = Injector.get<AppNavigator>();
  final AuthValidator _authValidator = Injector.get<AuthValidator>();
  final AuthApiClient _authApiClient = Injector.get<AuthApiClient>();
  late WidgetStatusEnum _widgetStatus = WidgetStatusEnum.Default;
  var _formKey = GlobalKey<FormState>();
  var _signupData = SignupDto();

  void _setWidgetStatus(WidgetStatusEnum status) {
    if (mounted) {
      setState(() {
        _widgetStatus = status;
      });
    }
  }

  void _saveForm() async {
    _formKey.currentState?.save();
    var isValid = _formKey.currentState?.validate();

    if (isValid == true) {
      _setWidgetStatus(WidgetStatusEnum.Loading);

      try {
        await _authApiClient.signup(_signupData, context);
        await showDialog(
          context: context,
          builder: (_) => ConfirmEmailDialog(),
        );
        _appNavigator.replaceCurrentUrl(LoginScreenWidget.screenUrl, context);
      } on ApiResponseException catch (e) {
        await showDialog(
          context: context,
          builder: (_) => ErrorDialog(error: e.errorResponse.message),
        );

        _setWidgetStatus(WidgetStatusEnum.Default);
      } catch (e) {
        _setWidgetStatus(WidgetStatusEnum.Default);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExitWarningOnPopWidget(
      child: AppScaffold(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 80),
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppLogoWidget(),
                  InputField(
                    label: 'Name',
                    margin: EdgeInsets.only(bottom: 30),
                    onSaved: (val) => _signupData.name = val ?? "",
                    validator: _authValidator.validateName,
                    textInputAction: TextInputAction.next,
                  ),
                  InputField(
                    label: 'Email',
                    margin: EdgeInsets.only(bottom: 30),
                    onSaved: (val) => _signupData.email = val ?? "",
                    validator: _authValidator.validateEmail,
                    textInputAction: TextInputAction.next,
                  ),
                  InputField(
                    label: 'Password',
                    margin: EdgeInsets.only(bottom: 30),
                    obscureText: true,
                    onSaved: (val) => _signupData.password = val ?? "",
                    validator: _authValidator.validatePassword,
                    textInputAction: TextInputAction.next,
                  ),
                  InputField(
                    label: 'Password Confirmation',
                    margin: EdgeInsets.only(bottom: 30),
                    obscureText: true,
                    onSaved: (val) => _signupData.passwordConfirmation = val ?? "",
                    validator: (val) => _authValidator.validatePasswordConfirmation(_signupData.password, val),
                    textInputAction: TextInputAction.done,
                  ),
                  RoundedButton(
                    child: _widgetStatus == WidgetStatusEnum.Loading
                        ? AppSpinner()
                        : const Text(
                            'SIGNUP',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    bgColor: const Color(AppColors.green),
                    onPressed: _saveForm,
                    disabled: _widgetStatus == WidgetStatusEnum.Loading,
                  ),
                  TextButton(
                    onPressed: _widgetStatus == WidgetStatusEnum.Loading
                        ? null
                        : () => _appNavigator.replaceCurrentUrl(LoginScreenWidget.screenUrl, context),
                    child: Text(
                      'switch to login',
                      style: TextStyle(
                        color: Color(AppColors.green),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
