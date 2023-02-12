import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/shared/app_color.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PageContainer extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool isShowAppBar;
  final List<SingleChildWidget> bloc;
  final List<SingleChildWidget> di;
  final List<Widget>? actions;

  const PageContainer(
      {Key? key,
      this.title,
      this.isShowAppBar = false,
      this.actions,
      required this.child,
      this.bloc = const [],
      this.di = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...di,
        ...bloc,
      ],
      child: Scaffold(
          appBar: isShowAppBar
              ? AppBar(
                  centerTitle: true,
                  title: Text(
                    title!,
                    style: TextStyle(color: AppColor.blue),
                  ),
                  actions: actions,
                )
              : null,
          body: Container(
            child: child,
          )),
    );
  }
}
