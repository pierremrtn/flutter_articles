import 'package:flutter/material.dart';
import 'package:how_to_prevent_widgets_from_animating_offscreen/editor.dart';

import 'counter.dart';

void main() {
  runApp(const HowToPreventWidgetsfromAnimatingOffscreen());
}

final routeObserver = RouteObserver();

class HowToPreventWidgetsfromAnimatingOffscreen extends StatelessWidget {
  const HowToPreventWidgetsfromAnimatingOffscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      title: 'How to prevent widgets from animating offscreen',
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      routes: {
        '/': (context) => const CounterPage(),
        '/editor': (context) => const EditorPage(),
      },
    );
  }
}
