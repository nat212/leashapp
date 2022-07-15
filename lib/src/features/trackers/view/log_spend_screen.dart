import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leashapp/src/shared/extensions.dart';
import 'package:leashapp/src/shared/models/models.dart';
import 'package:leashapp/src/shared/providers/settings.dart';
import 'package:leashapp/src/shared/providers/trackers.dart';

class LogSpendScreen extends StatefulWidget {
  const LogSpendScreen({Key? key, required this.trackerId, this.logId})
      : super(key: key);

  final int trackerId;

  final int? logId;

  @override
  State<LogSpendScreen> createState() => _LogSpendScreenState();
}

class _LogSpendScreenState extends State<LogSpendScreen> {
  final _formKey = GlobalKey<FormState>();
  double? _amount;
  String? _label;

  bool get _hasLog => widget.logId != null;

  Log? get _log =>
      _hasLog ? TrackerProvider.instance.getLog(widget.logId!) : null;

  @override
  void initState() {
    super.initState();
    if (_hasLog) {
      _amount = _log!.amount;
      _label = _log!.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracker = TrackerProvider.instance.get(widget.trackerId);
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
      floatingActionButton: tracker != null
          ? FloatingActionButton.extended(
              onPressed: () {
                _save(tracker);
              },
              label: const Text('Save'),
              icon: const Icon(Icons.save))
          : null,
    );
  }

  void _save(Tracker tracker) {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_hasLog) {
        final log = Log(amount: _amount!, label: _label!);
        TrackerProvider.instance.addLog(tracker: tracker, log: log);
      } else {
        _log!.amount = _amount!;
        _log!.label = _label!;
        _log!.save();
      }
      GoRouter.of(context).pop();
    }
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
    return Container(
        alignment: Alignment.topCenter,
        child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxWidth: min(constraints.maxWidth * 0.6, 600),
            ),
            child: Column(
              children: [
                _buildHeader(context, tracker),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildForm(context, tracker),
              ],
            )));
  }

  Widget _buildMobileBody(
      BuildContext context, BoxConstraints constraints, Tracker tracker) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(context, tracker),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildForm(context, tracker),
          ],
        ));
  }

  Widget _buildHeader(BuildContext context, Tracker tracker) {
    final currency = SettingsProvider.currency;
    final theme = Theme.of(context);
    final amountTheme =
        theme.textTheme.headline5!.copyWith(color: theme.colorScheme.secondary);
    final errorAmountTheme =
        amountTheme.copyWith(color: theme.colorScheme.error);
    final labelTheme =
        theme.textTheme.subtitle2!.copyWith(color: theme.colorScheme.secondary);
    final remaining = tracker.remaining - (_amount ?? 0);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(currency.format(remaining),
                style: remaining < 0 ? errorAmountTheme : amountTheme),
            const SizedBox(width: 8),
            Text('remaining', style: labelTheme),
          ],
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, Tracker tracker) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Label *',
            ),
            initialValue: _label,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Label is required';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _label = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Amount *',
              prefixText: SettingsProvider.currency.symbol,
            ),
            keyboardType: TextInputType.number,
            initialValue: _amount?.toString(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              } else if (double.tryParse(value) == null) {
                return 'Please enter a valid amount';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _amount = double.tryParse(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
