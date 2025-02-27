import 'package:charts/simple_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';

import '../../../../../shared/helpers/analytics.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../screens/market/model/market_item_model.dart';
import '../../../../screens/market/notifier/watchlist/watchlist_notipod.dart';
import '../../../helpers/currency_from.dart';
import '../../../helpers/supports_recurring_buy.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../actions/action_recurring_buy/action_recurring_buy.dart';
import '../../actions/action_recurring_buy/action_with_out_recurring_buy.dart';
import '../../actions/action_recurring_info/action_recurring_info.dart';
import '../../actions/action_sell/action_sell.dart';
import '../../chart/notifier/asset_chart_input_stpod.dart';
import '../../chart/notifier/chart_notipod.dart';
import '../../chart/notifier/chart_union.dart';
import '../../chart/view/asset_chart.dart';
import '../../currency_buy/view/curency_buy.dart';
import '../../kyc/model/kyc_operation_status_model.dart';
import '../../kyc/notifier/kyc/kyc_notipod.dart';
import '../../recurring/notifier/recurring_buys_notipod.dart';
import '../../recurring/view/recurring_buy_banner.dart';
import '../../wallet/notifier/operation_history_notipod.dart';
import '../../wallet/provider/operation_history_fpod.dart';
import '../notifier/market_news_notipod.dart';
import '../provider/market_info_fpod.dart';
import '../provider/market_news_fpod.dart';
import 'components/about_block/about_block.dart';
import 'components/asset_day_change.dart';
import 'components/asset_price.dart';
import 'components/balance_block/balance_block.dart';
import 'components/index_allocation_block/index_allocation_block.dart';
import 'components/index_history_block/index_history_block.dart';
import 'components/market_info_loader_block/market_info_loader_block.dart';
import 'components/market_news_block/market_news_block.dart';
import 'components/market_stats_block/market_stats_block.dart';
import 'components/return_rates_block/return_rates_block.dart';

class MarketDetails extends HookWidget {
  const MarketDetails({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);
    final marketInfo = useProvider(
      marketInfoFpod(
        marketItem.associateAsset,
      ),
    );
    final chartN = useProvider(
      chartNotipod(
        useProvider(assetChartInputStpod(marketItem)).state,
      ).notifier,
    );
    final watchlistIdsN = useProvider(watchlistIdsNotipod.notifier);
    final initTransactionHistory = useProvider(
      operationHistoryInitFpod(
        marketItem.symbol,
      ),
    );
    final transactionHistory = useProvider(
      operationHistoryNotipod(
        marketItem.symbol,
      ),
    );
    final newsInit = useProvider(marketNewsInitFpod(marketItem.symbol));
    final news = useProvider(marketNewsNotipod);
    final chart = useProvider(
      chartNotipod(
        useProvider(assetChartInputStpod(marketItem)).state,
      ),
    );
    useProvider(watchlistIdsNotipod);
    final currency = currencyFrom(currencies, marketItem.symbol);
    final recurringNotifier = useProvider(recurringBuysNotipod.notifier);
    final kycState = useProvider(kycNotipod);
    final kycAlertHandler = useProvider(kycAlertHandlerPod(context));

    final filteredRecurringBuys = recurringNotifier.recurringBuys
        .where(
          (element) => element.toAsset == currency.symbol,
        )
        .toList();

    final moveToRecurringInfo = filteredRecurringBuys.length == 1;

    final lastRecurringItem =
        filteredRecurringBuys.isNotEmpty ? filteredRecurringBuys[0] : null;

    analytics(() => sAnalytics.assetView(marketItem.name));

    return SPageFrame(
      header: Material(
        color: chart.union != const ChartUnion.loading()
            ? Colors.transparent
            : colors.grey5,
        child: SPaddingH24(
          child: SSmallHeader(
            title: '${marketItem.name} (${marketItem.symbol})',
            showStarButton: true,
            isStarSelected:
                watchlistIdsN.isInWatchlist(marketItem.associateAsset),
            onStarButtonTap: () {
              if (watchlistIdsN.isInWatchlist(marketItem.associateAsset)) {
                watchlistIdsN.removeFromWatchlist(marketItem.associateAsset);
              } else {
                sAnalytics.addToWatchlist(marketItem.name);
                watchlistIdsN.addToWatchlist(marketItem.associateAsset);
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BalanceBlock(
        marketItem: marketItem,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (chart.union != const ChartUnion.loading())
              SizedBox(
                height: 104,
                child: Column(
                  children: [
                    AssetPrice(
                      marketItem: marketItem,
                    ),
                    AssetDayChange(
                      marketItem: marketItem,
                    ),
                  ],
                ),
              ),
            if (chart.union == const ChartUnion.loading())
              Container(
                height: 104,
                width: double.infinity,
                color: colors.grey5,
                child: Column(
                  children: const [
                    SpaceH17(),
                    SSkeletonTextLoader(
                      height: 24,
                      width: 152,
                    ),
                    SpaceH10(),
                    SSkeletonTextLoader(
                      height: 16,
                      width: 80,
                    ),
                    SpaceH37(),
                  ],
                ),
              ),
            AssetChart(
              marketItem,
              (ChartInfoModel? chartInfo) {
                chartN.updateSelectedCandle(chartInfo?.right);
              },
            ),
            initTransactionHistory.when(
              data: (data) {
                if (marketItem.type == AssetType.indices &&
                    transactionHistory.operationHistoryItems.isNotEmpty) {
                  return Column(
                    children: [
                      const SpaceH40(),
                      IndexHistoryBlock(
                        marketItem: marketItem,
                      )
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
              loading: () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SpaceH40(),
                  SSkeletonTextLoader(
                    height: 16,
                    width: 133,
                  ),
                ],
              ),
              error: (_, __) => const SizedBox(),
            ),
            ReturnRatesBlock(
              assetSymbol: marketItem.associateAsset,
            ),
            const SpaceH40(),
            if (supportsRecurringBuy(marketItem.symbol, currencies))
              RecurringBuyBanner(
                title: recurringNotifier.recurringBannerTitle(
                  asset: currency.symbol,
                  context: context,
                ),
                type: recurringNotifier.type(currency.symbol),
                topMargin: 0,
                onTap: () {
                  // Todo: need refactor
                  if (kycState.sellStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    if (recurringNotifier.activeOrPausedType(currency.symbol)) {
                      if (moveToRecurringInfo && lastRecurringItem != null) {
                        navigatorPush(
                          context,
                          ShowRecurringInfoAction(
                            recurringItem: lastRecurringItem,
                            assetName: currency.description,
                          ),
                        );
                      } else {
                        showRecurringBuyAction(
                          context: context,
                          currency: currency,
                          total: recurringNotifier.totalRecurringByAsset(
                            asset: currency.symbol,
                          ),
                        );
                      }
                    } else {
                      var dismissWasCall= false;
                      showActionWithoutRecurringBuy(
                        title: intl.recurringBuysName_empty,
                        context: context,
                        onItemTap: (RecurringBuysType type) {
                          navigatorPushReplacement(
                            context,
                            CurrencyBuy(
                              currency: currency,
                              fromCard: false,
                              recurringBuysType: type,
                            ),
                          );
                        },
                        onDissmis: () => {
                          dismissWasCall= true,
                          sAnalytics.closeRecurringBuySheet(
                            currency.description,
                            Source.marketScreen,
                          ),
                        },
                        then: (val) => {
                          if (val == null && !dismissWasCall)
                            {
                              sAnalytics.closeRecurringBuySheet(
                                currency.description,
                                Source.marketScreen,
                              ),
                            }
                        },
                      );
                    }
                  } else {
                    sAnalytics.setupRecurringBuyView(
                      currency.description,
                      Source.assetScreen,
                    );

                    kycAlertHandler.handle(
                      status: kycState.sellStatus,
                      kycVerified: kycState,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () => showSellAction(context),
                    );
                  }
                },
              ),
            if (marketItem.type == AssetType.indices) ...[
              IndexAllocationBlock(
                marketItem: marketItem,
              ),
              // const IndexOverviewBlock(),
            ],
            marketInfo.when(
              data: (marketInfo) {
                return SPaddingH24(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (marketInfo != null) ...[
                        if (marketItem.type != AssetType.indices) ...[
                          const SpaceH20(),
                          MarketStatsBlock(
                            marketInfo: marketInfo,
                          ),
                        ],
                        AboutBlock(
                          marketInfo: marketInfo,
                          showDivider: news.news.isNotEmpty,
                        ),
                      ],
                    ],
                  ),
                );
              },
              loading: () => const MarketInfoLoaderBlock(),
              error: (_, __) => const SizedBox(),
            ),
            newsInit.when(
              data: (_) {
                return MarketNewsBlock(
                  news: news.news,
                  assetId: marketItem.associateAsset,
                );
              },
              loading: () => SPaddingH24(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SpaceH40(),
                    SSkeletonTextLoader(
                      height: 16,
                      width: 133,
                    ),
                  ],
                ),
              ),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
