import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../provider/market_watchlist_items_pod.dart';
import '../fade_on_scroll.dart';
import 'components/empty_watchlist.dart';
import 'components/market_header_stats.dart';
import 'components/market_reordable_list.dart';
import 'helper/reset_market_scroll_position.dart';

class WatchlistTabBarView extends StatefulHookWidget {
  const WatchlistTabBarView({Key? key}) : super(key: key);

  @override
  State<WatchlistTabBarView> createState() => _WatchlistTabBarViewState();
}

class _WatchlistTabBarViewState extends State<WatchlistTabBarView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final watchItems = context.read(marketWatchlistItemsPod);

    sAnalytics.marketFilter(FilterMarketTabAction.watchlist);

    _scrollController.addListener(() {
      resetMarketScrollPosition(
        context,
        watchItems.length,
        _scrollController,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchItems = useProvider(marketWatchlistItemsPod);
    final intl = useProvider(intlPod);

    if (watchItems.isNotEmpty) {
      return NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              elevation: 0,
              expandedHeight: 160,
              collapsedHeight: 120,
              primary: false,
              flexibleSpace: FadeOnScroll(
                scrollController: _scrollController,
                fullOpacityOffset: 50,
                fadeInWidget: const SDivider(
                  width: double.infinity,
                ),
                fadeOutWidget: const MarketHeaderStats(),
                permanentWidget: SMarketHeaderClosed(
                  title: intl.watchlistTabBarView_market,
                ),
              ),
            ),
          ];
        },
        body: const MarketReorderableList(),
      );
    } else {
      return const EmptyWatchlist();
    }
  }
}
