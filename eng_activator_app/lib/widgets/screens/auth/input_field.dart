import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String _label;
  final EdgeInsets? _margin;
  final Function(String?)? _onSaved;
  final String? Function(String?)? _validator;
  final bool _obscure;

  const InputField({
    Key? key,
    required String label,
    EdgeInsets? margin,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    bool obscureText = false,
  })  : _label = label,
        _onSaved = onSaved,
        _validator = validator,
        _margin = margin,
        _obscure = obscureText,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _margin,
      constraints: BoxConstraints(maxWidth: 400),
      child: TextFormField(
        onSaved: _onSaved,
        validator: _validator,
        obscureText: _obscure,
        decoration: InputDecoration(
          labelText: _label,
          labelStyle: const TextStyle(
            fontSize: 14,
            color: Color(AppColors.green),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: const BorderSide(
              color: Color(AppColors.green),
              width: 2.5,
            ),
          ),
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
