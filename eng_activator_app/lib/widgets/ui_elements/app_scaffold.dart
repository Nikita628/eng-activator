import 'package:eng_activator_app/shared/services/event_hub.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_bar.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_drawer.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatefulWidget {
  final Widget _child;
  final bool _isAppBarShown;

  const AppScaffold({Key? key, required Widget child, bool isAppBarShown = false})
      : _child = child,
        _isAppBarShown = isAppBarShown,
        super(key: key);

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final EventHub _eventHub = Injector.get<EventHub>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _eventHub.addOrReplaceListener('scrollPageUp_AppScaffold', () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
      }
    });

    _eventHub.addOrReplaceListener('scrollPageDown_AppScaffold', () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 1000), curve: Curves.ease);
      }
    });

    _eventHub.addOrReplaceListener('updateScrollPosition_AppScaffold', () {
      if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
        _scrollController.jumpTo(0.01);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget._isAppBarShown ? AppBarWidget() : null,
      endDrawer: AppDrawer(),
      body: Scrollbar(
        thickness: 5,
        isAlwaysShown: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: widget._child,
        ),
      ),
    );
  }
}
