import 'package:flutter/material.dart';

import 'app_layout.dart';

class PlaybackLayout extends StatefulWidget {
  final Widget player;
  final Widget information;
  final int episodeCount;
  final IndexedWidgetBuilder episodeBuilder;

  const PlaybackLayout({
    super.key,
    required this.player,
    required this.information,
    required this.episodeCount,
    required this.episodeBuilder,
  });

  @override
  State<PlaybackLayout> createState() => _PlaybackLayoutState();
}

class _PlaybackLayoutState extends State<PlaybackLayout> {
  final _pageController = ScrollController();
  final _episodesController = ScrollController();
  final _informationController = ScrollController();

  @override
  void dispose() {
    _pageController.dispose();
    _episodesController.dispose();
    _informationController.dispose();
    super.dispose();
  }

  SliverGridDelegate get _episodeGrid =>
      const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 130,
        mainAxisExtent: 44,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      );

  Widget get _player => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColoredBox(
          color: Colors.black,
          child: AspectRatio(aspectRatio: 16 / 9, child: widget.player),
        ),
      );

  Widget _episodeHeading(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Text('选集', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 8),
            Text('${widget.episodeCount} 集',
                style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            const Chip(label: Text('M3U8')),
          ],
        ),
      );

  Widget _desktop(BuildContext context, BoxConstraints constraints) {
    final sidebarWidth = constraints.maxWidth >= 1600 ? 360.0 : 320.0;
    final informationHeight =
        (constraints.maxHeight * 0.23).clamp(120.0, 200.0);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: Center(child: _player)),
              const SizedBox(height: 16),
              SizedBox(
                height: informationHeight,
                child: Scrollbar(
                  controller: _informationController,
                  child: SingleChildScrollView(
                    controller: _informationController,
                    padding: const EdgeInsets.only(right: 12),
                    child: widget.information,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: sidebarWidth,
          child: Card.outlined(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _episodeHeading(context),
                  Expanded(
                    child: widget.episodeCount == 0
                        ? const Center(child: Text('暂无剧集'))
                        : Scrollbar(
                            controller: _episodesController,
                            thumbVisibility: true,
                            child: GridView.builder(
                              controller: _episodesController,
                              primary: false,
                              padding: const EdgeInsets.only(right: 8),
                              gridDelegate: _episodeGrid,
                              itemCount: widget.episodeCount,
                              itemBuilder: widget.episodeBuilder,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _compact(BuildContext context) => Scrollbar(
        controller: _pageController,
        child: CustomScrollView(
          controller: _pageController,
          slivers: [
            SliverToBoxAdapter(child: _player),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: widget.information,
              ),
            ),
            SliverToBoxAdapter(child: _episodeHeading(context)),
            if (widget.episodeCount == 0)
              const SliverToBoxAdapter(child: Center(child: Text('暂无剧集')))
            else
              SliverGrid(
                gridDelegate: _episodeGrid,
                delegate: SliverChildBuilderDelegate(
                  widget.episodeBuilder,
                  childCount: widget.episodeCount,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.playbackMaxWidth,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => Padding(
                padding: AppLayout.contentPadding(constraints.maxWidth),
                child: LayoutBuilder(
                  builder: (context, innerConstraints) =>
                      constraints.maxWidth >= AppLayout.playbackBreakpoint &&
                              innerConstraints.maxHeight >= 480
                          ? _desktop(context, innerConstraints)
                          : _compact(context),
                ),
              ),
            ),
          ),
        ),
      );
}
