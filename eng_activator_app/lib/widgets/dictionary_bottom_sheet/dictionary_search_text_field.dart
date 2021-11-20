import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/material.dart';

class DictionarySearchTextField extends StatefulWidget {
  final void Function(String) _onSearchIconClick;

  DictionarySearchTextField({
    required void Function(String) onSearchIconClick,
  })  : _onSearchIconClick = onSearchIconClick,
        super();

  @override
  _DictionarySearchTextFieldState createState() => _DictionarySearchTextFieldState();
}

class _DictionarySearchTextFieldState extends State<DictionarySearchTextField> {
  final TextEditingController _textFieldController = TextEditingController();
  final _searchBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
    borderSide: BorderSide(width: 1, color: Color(AppColors.green)),
  );

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textFieldController,
      onSubmitted: (value) => widget._onSearchIconClick(value),
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 5),
        hintText: 'Search dictionary...',
        hintStyle: const TextStyle(color: Color(AppColors.grey)),
        filled: true,
        isDense: true,
        fillColor: Colors.white,
        suffixIconConstraints: const BoxConstraints(minHeight: 5, minWidth: 5),
        suffixIcon: IconButton(
          onPressed: () => widget._onSearchIconClick(_textFieldController.text),
          icon: const Icon(
            Icons.search,
            color: Color(AppColors.green),
          ),
          padding: const EdgeInsets.all(5),
          constraints: const BoxConstraints(minHeight: 5, minWidth: 5),
        ),
        border: _searchBorder,
        enabledBorder: _searchBorder,
        focusedBorder: _searchBorder,
      ),
    );
  }
}
