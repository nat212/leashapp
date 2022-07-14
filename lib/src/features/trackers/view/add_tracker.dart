import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 300),
            child: Form(
                key: _formKey,
                child: Column(
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
                      decoration: const InputDecoration(
                        labelText: 'Amount *',
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _amount =
                              value != null ? double.tryParse(value) : null;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed:
                                _formKey.currentState?.validate() ?? false
                                    ? () {
                                        Navigator.of(context).pop(widget.tracker
                                                ?.update(
                                                    name: _name,
                                                    description: _description,
                                                    amount: _amount) ??
                                            Tracker(
                                              amount: _amount ?? 0,
                                              name: _name ?? '',
                                              description: _description ?? '',
                                            ));
                                      }
                                    : null,
                            child: const Text('Submit')),
                      ],
                    )
                  ],
                ))));
  }
}
