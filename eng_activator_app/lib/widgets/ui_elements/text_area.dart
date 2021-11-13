import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextAreaWidget extends StatefulWidget {
  final EdgeInsets? _margin;
  final Function(String)? _onChanged;
  final Function(String?)? _onSaved;
  final String? Function(String?)? _validator;
  final String _value;
  final String? _placeholder;

  AppTextAreaWidget({
    EdgeInsets? margin,
    Function(String)? onChanged,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    String value = '',
    String placeholder = '',
  })  : _margin = margin,
        _value = value,
        _onSaved = onSaved,
        _validator = validator,
        _placeholder = placeholder,
        _onChanged = onChanged;

  @override
  _AppTextAreaWidgetState createState() => _AppTextAreaWidgetState();
}

class _AppTextAreaWidgetState extends State<AppTextAreaWidget> {
  final _focusNode = FocusNode();
  late String _currentInputValue;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _currentInputValue = widget._value;
    _controller = TextEditingController(text: widget._value);

    _controller.addListener(() {
      var isValueChanged = _controller.text != _currentInputValue;

      if (isValueChanged && widget._onChanged != null) {
        _currentInputValue = _controller.text;
        widget._onChanged!(_currentInputValue);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  void didUpdateWidget(covariant AppTextAreaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _currentInputValue = widget._value;
      _controller.text = widget._value;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _currentInputValue.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget._margin,
      child: TextFormField(
        minLines: 5,
        maxLines: null,
        enableSuggestions: false,
        autocorrect: false,
        onSaved: widget._onSaved,
        validator: widget._validator,
        maxLength: 1000,
        focusNode: _focusNode,
        controller: _controller,
        cursorColor: const Color(AppColors.green),
        autofocus: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          hintText: widget._placeholder,
          hintStyle: const TextStyle(color: Color(AppColors.grey)),
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(AppColors.green), width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
