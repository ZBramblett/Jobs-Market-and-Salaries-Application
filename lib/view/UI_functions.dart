// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '../presenter/theme_presenter.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final String style; // 'primary' or 'secondary'
  final String
  width; // 'fit' or 'span' for fitting content or taking as much space as possible
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.style = 'primary',
    this.width = 'fit',
    required this.onPressed,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
    );

    final tween = Tween<double>(begin: 0.90, end: 1.0);

    final animationCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
      reverseCurve: Curves.elasticInOut,
    );
    _scaleAnimation = tween.animate(animationCurve);
    themePresenter.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themePresenter.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Color bgColor;
    Color fgColor;

    switch (widget.style) {
      case 'primary':
        bgColor = scheme.primary;
        fgColor = scheme.onPrimary;
        break;
      case 'secondary':
        bgColor = scheme.secondary;
        fgColor = scheme.onSecondary;
        break;
      case 'error':
        bgColor = scheme.error;
        fgColor = scheme.onError;
        break;
      default:
        bgColor = scheme.primary;
        fgColor = scheme.onPrimary;
    }
    final radius = BorderRadius.circular(
      themePresenter.BORDER_RADIUS.toDouble(),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        4, //left
        4, // top
        4, // right
        4, // bottom
      ),
      child: Listener(
        onPointerDown: (_) => _controller.reverse(),
        onPointerUp: (_) => _controller.forward(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: widget.width == 'span' ? double.infinity : null,
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                shadowColor: bgColor,
                elevation: 2,
                backgroundColor: bgColor,
                foregroundColor: fgColor,
                shape: RoundedRectangleBorder(borderRadius: radius),
              ),
              child: Text(widget.text),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback? onPressed;

  const CustomCard({
    super.key,
    required this.title,
    required this.description,
    this.onPressed,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  void initState() {
    super.initState();
    themePresenter.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themePresenter.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(
      themePresenter.BORDER_RADIUS.toDouble(),
    );

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: scheme.onSurface.withAlpha(125),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                if (widget.onPressed != null) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: widget.onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: radius),
                      minimumSize: const Size(40, 40),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.play_arrow),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(fontSize: 14, color: scheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
