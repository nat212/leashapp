import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leashapp/src/shared/extensions.dart';
import 'package:leashapp/src/shared/models/models.dart';
import 'package:leashapp/src/shared/providers/trackers.dart';

class LogSpendScreen extends StatefulWidget {
  const LogSpendScreen({Key? key, required this.trackerId}) : super(key: key);

  final int trackerId;

  @override
  State<LogSpendScreen> createState() => _LogSpendScreenState();
}

class _LogSpendScreenState extends State<LogSpendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Spend'),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text('Save'),
          icon: const Icon(Icons.save)),
    );
  }

  Widget _buildBody() {
    final tracker = TrackerProvider.instance.get(widget.trackerId);
    return tracker != null
        ? LayoutBuilder(builder: (context, constraints) {
            return constraints.isMobile
                ? _buildMobileBody(context, constraints, tracker)
                : _buildDesktopBody(context, constraints, tracker);
          })
        : _buildNotFound();
  }

  Widget _buildNotFound() {
    return Container();
  }

  Widget _buildDesktopBody(
      BuildContext context, BoxConstraints constraints, Tracker tracker) {
    return Container();
  }

  Widget _buildMobileBody(
      BuildContext context, BoxConstraints constraints, Tracker tracker) {
    return Container();
  }
}
