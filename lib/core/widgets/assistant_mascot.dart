import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A small greeting animation that also respects reduced-motion preferences.
class AssistantMascot extends StatefulWidget {
  const AssistantMascot({super.key, this.hideEyes = false});

  final bool hideEyes;

  @override
  State<AssistantMascot> createState() => _AssistantMascotState();
}

class _AssistantMascotState extends State<AssistantMascot> {
  int _greeting = 0;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: 'Sapa asisten kecil',
      button: true,
      child: Tooltip(
        message: 'Hai! Semangat untuk hari ini!',
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () => setState(() => _greeting++),
          child: TweenAnimationBuilder<double>(
            key: ValueKey(_greeting),
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: reduceMotion ? 0 : 1200),
            builder: (context, value, child) => Transform.translate(
              offset: Offset(
                0,
                -10 * math.sin(value * math.pi * 2) * (1 - value),
              ),
              child: Transform.rotate(
                angle: reduceMotion
                    ? 0
                    : math.sin(value * math.pi * 4) * 0.12 * (1 - value),
                child: child,
              ),
            ),
            child: SizedBox(
              width: 112,
              height: 94,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 86,
                    height: 76,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDF5F1),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: reduceMotion ? 0 : 200),
                      child: Icon(
                        widget.hideEyes
                            ? Icons.sentiment_satisfied_alt
                            : Icons.smart_toy_rounded,
                        key: ValueKey(widget.hideEyes),
                        size: 46,
                        color: const Color(0xFF123C69),
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFF6BE55),
                      size: 26,
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    bottom: 4,
                    child: Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFF3A6B5),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
