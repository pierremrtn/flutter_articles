import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_to_prevent_widgets_from_animating_offscreen/business_logic.dart';

import 'counter_bloc.dart';
import 'main.dart';

const _duration = Duration(seconds: 1);
const _curve = Curves.easeInOut;

class CounterPage extends StatelessWidget {
  const CounterPage({
    super.key,
  });

  void _openEditor(BuildContext context) {
    Navigator.of(context).pushNamed('/editor');
  }

  void _randomlySetValue() {
    final newValue = (Random().nextDouble() * 100).round();
    BusinessLogic.instance.value = newValue;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc()..add(CounterEvent.started),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('How to prevent widgets from animating offscreen'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 233,
                height: 233,
                child: _CounterConsumer(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 233,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      onPressed: _randomlySetValue,
                      child: const Text('Randomly set value'),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => _openEditor(context),
                      child: const Text('Open editor'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CounterConsumer extends StatelessWidget {
  const _CounterConsumer();

  @override
  Widget build(BuildContext context) {
    final value = context.select((CounterBloc bloc) => bloc.state);
    return _UpdateOnlyWhenVisible(
      value: value,
    );
  }
}

class _UpdateOnlyWhenVisible extends StatefulWidget {
  const _UpdateOnlyWhenVisible({
    required this.value,
  });
  final int value;

  @override
  _UpdateOnlyWhenVisibleState createState() => _UpdateOnlyWhenVisibleState();
}

class _UpdateOnlyWhenVisibleState extends State<_UpdateOnlyWhenVisible>
    with RouteAware {
  late int _effectiveValue = widget.value;
  bool _visible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didUpdateWidget(old) {
    super.didUpdateWidget(old);
    if (_visible) {
      _effectiveValue = widget.value;
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    _visible = false;
  }

  @override
  void didPopNext() {
    _visible = true;
    if (_effectiveValue != widget.value) {
      setState(() {
        _effectiveValue = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedCounter(
      max: 100,
      value: _effectiveValue,
    );
  }
}

class _AnimatedCounter extends ImplicitlyAnimatedWidget {
  const _AnimatedCounter({
    required this.max,
    required this.value,
  }) : super(
          duration: _duration,
          curve: _curve,
        );

  final int max;
  final int value;

  @override
  _AnimatedMainIndicatorState createState() => _AnimatedMainIndicatorState();
}

class _AnimatedMainIndicatorState
    extends ImplicitlyAnimatedWidgetState<_AnimatedCounter> with RouteAware {
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _valueTween = visitor(
      _valueTween,
      widget.value,
      (dynamic value) => IntTween(begin: value),
    ) as IntTween?;
  }

  IntTween? _valueTween;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final value = _valueTween?.evaluate(animation) ?? 0;
        return _Counter(
          arcValue: (value / widget.max.toDouble()).clamp(0, 1),
          text: value.round().toString(),
        );
      },
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.arcValue,
    required this.text,
  });

  final double arcValue;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _ArcBar(value: arcValue),
        Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ],
    );
  }
}

class _ArcBar extends StatelessWidget {
  const _ArcBar({
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArcBarPainter(
        backgroundColor: Colors.white38,
        foregroundColor: Colors.white,
        value: value,
      ),
      child: const AspectRatio(aspectRatio: 1),
    );
  }
}

class _ArcBarPainter extends CustomPainter {
  _ArcBarPainter({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.value,
  });

  final Color foregroundColor;
  final Color backgroundColor;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final thickness = (size.width / 2) * .15;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    const sweep = 1.5 * pi;
    final foregroundSweep = sweep * value;
    final rect = Offset(thickness / 2, thickness / 2) &
        Size(size.width - thickness, size.height - thickness);
    canvas.drawArc(
      rect,
      (3 * pi) / 4,
      sweep,
      false,
      paint..color = backgroundColor,
    );

    canvas.drawArc(
      rect,
      (3 * pi) / 4,
      foregroundSweep,
      false,
      paint..color = foregroundColor,
    );
  }

  @override
  bool shouldRepaint(_ArcBarPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.foregroundColor != foregroundColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
