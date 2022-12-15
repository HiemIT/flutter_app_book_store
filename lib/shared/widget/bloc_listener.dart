import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/base/base_bloc.dart';
import 'package:flutter_app_book_store/base/base_even.dart';
import 'package:provider/provider.dart';

class BlocListener<T extends BaseBloc> extends StatefulWidget {
  final Widget? child;
  final Function(BaseEvent event)? listener;

  const BlocListener({super.key,
    @required this.child,
    @required this.listener,
  });

  @override
  _BlocListenerState createState() => _BlocListenerState<T>();
}

class _BlocListenerState<T> extends State<BlocListener> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = Provider.of<T>(context) as BaseBloc;

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseEvent>(
      builder: (context, event, child) {
        return Container(
          child: widget.child,
        );
      },
    );
  }
}
