import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leashapp/src/shared/extensions.dart';
import 'package:leashapp/src/shared/providers/settings.dart';
import 'package:leashapp/src/shared/providers/trackers.dart';

import '../../../shared/models/models.dart';

class AddTracker extends StatefulWidget {
  const AddTracker({Key? key, this.tracker}) : super(key: key);

  final Tracker? tracker;

  @override
  State<AddTracker> createState() => _AddTrackerState();
}

class _AddTrackerState extends State<AddTracker> {
  String? _name;
  String? _description;
  double? _amount;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = widget.tracker?.name;
    _description = widget.tracker?.description;
    _amount = widget.tracker?.amount;
  }

  Widget _desktopView(
      {required BuildContext context,
      required BoxConstraints constraints,
      required Widget child}) {
    return Container(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: min(constraints.maxWidth * 0.8, 600),
          ),
          padding: const EdgeInsets.all(16),
          child: child,
        ));
  }

  Widget _mobileView(
      {required BuildContext context,
      required BoxConstraints constraints,
      required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.tracker == null ? 'Add' : 'Edit'} Tracker'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _save();
            },
            label: const Text('Save'),
            icon: const Icon(Icons.save)),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        body: SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) {
          return Form(
              key: _formKey,
              child: constraints.isMobile
                  ? _mobileView(
                      context: context,
                      constraints: constraints,
                      child: _buildBody())
                  : _desktopView(
                      context: context,
                      constraints: constraints,
                      child: _buildBody()));
        })));
  }

  Widget _buildBody() {
    final currency = SettingsProvider.currency;
    final currencySymbol = currency.symbol;
    final symbolOnLeft = currency.symbolOnLeft;
    final spaceBetween = currency.spaceBetweenAmountAndSymbol;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('${widget.tracker != null ? 'Edit' : 'Add'} Tracker',
            style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 32),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Name *',
          ),
          onChanged: (String? value) {
            setState(() {
              _name = value;
            });
          },
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Name is required';
            }
            return null;
          },
          initialValue: _name,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Description',
          ),
          onChanged: (String? value) {
            setState(() {
              _description = value;
            });
          },
          minLines: 2,
          maxLines: 5,
          maxLength: 250,
          initialValue: _description,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Amount *',
            prefixText: symbolOnLeft
                ? '$currencySymbol${spaceBetween ? ' ' : ''}'
                : null,
            suffixText: !symbolOnLeft
                ? '${spaceBetween ? ' ' : ''}$currencySymbol'
                : null,
          ),
          onChanged: (String? value) {
            setState(() {
              _amount = value != null ? double.tryParse(value) : null;
            });
          },
          keyboardType: TextInputType.number,
          validator: (String? value) {
            if (value == null) {
              return 'Amount is required';
            }
            if (double.tryParse(value) == null) {
              return 'Amount must be a number';
            }
            return null;
          },
          initialValue: _amount?.toString(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (widget.tracker == null) {
        TrackerProvider.instance.addTracker(
            name: _name!, amount: _amount!, description: _description);
      } else {
        widget.tracker!
            .update(name: _name!, amount: _amount!, description: _description);
      }
      GoRouter.of(context).pop();
    }
  }
}
