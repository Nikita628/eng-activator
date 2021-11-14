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

    _eventHub.subscribe(AppEvents.ScrollPageUp, _scrollPageUp);
    _eventHub.subscribe(AppEvents.ScrollPageDown, _scrollPageDown);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
    _eventHub.unsubscribe(_scrollPageUp);
    _eventHub.unsubscribe(_scrollPageDown);
  }

  void _scrollPageUp() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
    }
  }

  void _scrollPageDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1000), curve: Curves.ease);
    }
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
