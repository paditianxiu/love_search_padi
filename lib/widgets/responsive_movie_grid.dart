import 'package:flutter/material.dart';

import 'app_layout.dart';

class ResponsiveMovieGrid extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const ResponsiveMovieGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<ResponsiveMovieGrid> createState() => _ResponsiveMovieGridState();
}

class _ResponsiveMovieGridState extends State<ResponsiveMovieGrid> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.contentMaxWidth,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop =
                  constraints.maxWidth >= AppLayout.navigationBreakpoint;
              final padding = AppLayout.contentPadding(constraints.maxWidth);
              final spacing = desktop ? 16.0 : 8.0;
              final targetWidth = desktop
                  ? 190.0
                  : constraints.maxWidth >= 600
                      ? 170.0
                      : 140.0;
              final availableWidth = constraints.maxWidth - padding.horizontal;
              final columns =
                  ((availableWidth + spacing) / (targetWidth + spacing))
                      .floor()
                      .clamp(1, 12);
              return Scrollbar(
                controller: _scrollController,
                thumbVisibility: desktop,
                child: GridView.builder(
                  controller: _scrollController,
                  primary: false,
                  padding: padding,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: widget.itemCount,
                  itemBuilder: widget.itemBuilder,
                ),
              );
            },
          ),
        ),
      );
}
