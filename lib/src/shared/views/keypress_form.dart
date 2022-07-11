import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeypressForm extends StatelessWidget {
  const KeypressForm(
      {Key? key,
      this.submitKey = LogicalKeyboardKey.enter,
      required this.child,
      required this.onSubmit,
      this.formKey})
      : super(key: key);

  final LogicalKeyboardKey submitKey;
  final Widget child;
  final void Function() onSubmit;
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        _SubmitIntent: _SubmitAction(),
      },
      child: Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
          SingleActivator(submitKey): _SubmitIntent(() => onSubmit()),
          if (submitKey == LogicalKeyboardKey.enter)
            const SingleActivator(LogicalKeyboardKey.numpadEnter): _SubmitIntent(
                () => onSubmit()),
        },
        child: Form(
          key: formKey,
          child: child,
        ),
      ),
    );
  }
}

class _SubmitAction extends Action<_SubmitIntent> {
  @override
  void invoke(_SubmitIntent intent) => intent.handler();
}

class _SubmitIntent extends Intent {
  const _SubmitIntent(this.handler);

  final VoidCallback handler;
}
