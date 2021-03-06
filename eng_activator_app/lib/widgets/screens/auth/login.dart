import 'package:eng_activator_app/models/auth/login_data.dart';
import 'package:eng_activator_app/services/api_clients/auth_api_client.dart';
import 'package:eng_activator_app/shared/api_exception.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/services/auth/auth_validator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:eng_activator_app/widgets/dialogs/error_dialog.dart';
import 'package:eng_activator_app/widgets/screens/auth/input_field.dart';
import 'package:eng_activator_app/widgets/screens/auth/reset_password_screen.dart';
import 'package:eng_activator_app/widgets/screens/auth/signup.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_logo.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:eng_activator_app/widgets/ui_elements/exit_warning_on_pop.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreenWidget extends StatefulWidget {
  static const screenUrl = '/login-screen-widget';

  const LoginScreenWidget({Key? key}) : super(key: key);

  @override
  _LoginScreenWidgetState createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  final AppNavigator _appNavigator = Injector.get<AppNavigator>();
  final AuthValidator _authValidator = Injector.get<AuthValidator>();
  final LoginDto _loginDataDto = LoginDto();
  final AuthApiClient _authApiClient = Injector.get<AuthApiClient>();
  late WidgetStatusEnum _widgetStatus = WidgetStatusEnum.Default;
  late AuthProvider _authProvider;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

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
        var response = await _authApiClient.login(_loginDataDto, context);
        await _authProvider.setAuthData(response);
        _appNavigator.replaceCurrentUrl(MainScreenWidget.screenUrl, context);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppLogoWidget(),
                InputField(
                  label: 'Email',
                  margin: EdgeInsets.only(bottom: 30),
                  onSaved: (val) => _loginDataDto.email = val ?? "",
                  validator: _authValidator.validateEmailOnLogin,
                  textInputAction: TextInputAction.next,
                ),
                InputField(
                  label: 'Password',
                  margin: EdgeInsets.only(bottom: 30),
                  onSaved: (val) => _loginDataDto.password = val ?? "",
                  validator: _authValidator.validatePasswordOnLogin,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
                RoundedButton(
                  child: _widgetStatus == WidgetStatusEnum.Loading
                      ? AppSpinner()
                      : const Text(
                          'LOGIN',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  bgColor: Color(AppColors.green),
                  onPressed: _saveForm,
                  disabled: _widgetStatus == WidgetStatusEnum.Loading,
                ),
                TextButton(
                  onPressed: _widgetStatus == WidgetStatusEnum.Loading
                      ? null
                      : () => _appNavigator.replaceCurrentUrl(SignupScreenWidget.screenUrl, context),
                  child: const Text(
                    'switch to signup',
                    style: TextStyle(
                      color: Color(AppColors.green),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _widgetStatus == WidgetStatusEnum.Loading
                      ? null
                      : () => _appNavigator.replaceCurrentUrl(ResetPasswordScreenWidget.screenUrl, context),
                  child: const Text(
                    'forgot password?',
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
    );
  }
}
