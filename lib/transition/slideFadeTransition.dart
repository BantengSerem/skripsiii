import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlideFadeTransition extends PageRouteBuilder {
  final Widget child;

  SlideFadeTransition({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                  Tween(end: const Offset(0, 0), begin: const Offset(1, 0))
                      .chain(CurveTween(curve: Curves.easeInOut))),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}

// class SlideTransitionPageRoute<T> extends MaterialPageRoute<T> {
//   SlideTransitionPageRoute(
//       {required WidgetBuilder builder, required RouteSettings settings})
//       : super(builder: builder, settings: settings);
//
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return SlideTransition(
//       position: Tween<Offset>(
//         begin: const Offset(0.0, 1.0),
//         end: Offset.zero,
//       ).animate(animation),
//       child: child,
//     );
//   }
// }
