import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/base/base_bloc.dart';
import 'package:flutter_app_book_store/shared/widget/scale_animation.dart';
import 'package:provider/provider.dart';

class LoadingTask extends StatelessWidget {
  final Widget? child;
  final BaseBloc? bloc;
  const LoadingTask({super.key, required this.child, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child!,
        Consumer<bool>(
          builder: (context, isLoading, child) {
            return isLoading
                ? ScaleAnimation(
                    child: Container(
                      width: 120,
                      height: 120,
                      color: Colors.black.withOpacity(0.5),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container();
          },
          child: child,
        ),
      ],
    );
  }
}
