import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../screens/market/view/components/fade_on_scroll.dart';
import '../../../../../helpers/supports_recurring_buy.dart';
import '../../../../../models/currency_model.dart';
import '../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../actions/action_recurring_buy/action_recurring_buy.dart';
import '../../../../actions/action_recurring_buy/action_with_out_recurring_buy.dart';
import '../../../../actions/action_recurring_info/action_recurring_info.dart';
import '../../../../actions/action_sell/action_sell.dart';
import '../../../../currency_buy/view/curency_buy.dart';
import '../../../../kyc/model/kyc_operation_status_model.dart';
import '../../../../kyc/notifier/kyc/kyc_notipod.dart';
import '../../../../recurring/notifier/recurring_buys_notipod.dart';
import '../../../../recurring/view/recurring_buy_banner.dart';
import 'components/card_block/components/wallet_card.dart';
import 'components/card_block/components/wallet_card_collapsed.dart';
import 'components/transactions_list/transactions_list.dart';

const _collapsedCardHeight = 200.0;
const _expandedCardHeight = 270.0;

class WalletBody extends StatefulHookWidget {
  const WalletBody({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  State<StatefulWidget> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);
    final recurring = useProvider(recurringBuysNotipod);
    final recurringN = useProvider(recurringBuysNotipod.notifier);
    final kycState = useProvider(kycNotipod);
    final kycAlertHandler = useProvider(kycAlertHandlerPod(context));

    final filteredRecurringBuys = recurring.recurringBuys
        .where(
          (element) => element.toAsset == widget.currency.symbol,
        )
        .toList();

    final moveToRecurringInfo = filteredRecurringBuys.length == 1;

    final lastRecurringItem =
        filteredRecurringBuys.isNotEmpty ? filteredRecurringBuys[0] : null;

    var walletBackground = walletGreenBackgroundImageAsset;

    if (!widget.currency.isGrowing) {
      walletBackground = walletRedBackgroundImageAsset;
    }

    return Material(
      color: colors.white,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          _snapAppbar();
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: colors.white,
              pinned: true,
              stretch: true,
              elevation: 0,
              expandedHeight: _expandedCardHeight,
              collapsedHeight: _collapsedCardHeight,
              automaticallyImplyLeading: false,
              primary: false,
              flexibleSpace: FadeOnScroll(
                scrollController: _scrollController,
                fullOpacityOffset: 33,
                fadeInWidget: WalletCardCollapsed(
                  currency: widget.currency,
                ),
                fadeOutWidget: WalletCard(
                  currency: widget.currency,
                ),
                permanentWidget: Stack(
                  children: [
                    SvgPicture.asset(
                      walletBackground,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    SPaddingH24(
                      child: SSmallHeader(
                        title: '${widget.currency.description}'
                            ' ${intl.walletBody_wallet}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (supportsRecurringBuy(widget.currency.symbol, currencies))
              SliverToBoxAdapter(
                child: RecurringBuyBanner(
                  type: recurringN.type(widget.currency.symbol),
                  title: recurringN.recurringBannerTitle(
                    asset: widget.currency.symbol,
                    context: context,
                  ),
                  onTap: () {
                    // Todo: need refactor
                    if (kycState.sellStatus ==
                        kycOperationStatus(KycStatus.allowed)) {
                      if (recurringN
                          .activeOrPausedType(widget.currency.symbol)) {
                        if (moveToRecurringInfo && lastRecurringItem != null) {
                          navigatorPush(
                            context,
                            ShowRecurringInfoAction(
                              recurringItem: lastRecurringItem,
                              assetName: widget.currency.description,
                            ),
                          );
                        } else {
                          showRecurringBuyAction(
                            context: context,
                            currency: widget.currency,
                            total: recurringN.totalRecurringByAsset(
                              asset: widget.currency.symbol,
                            ),
                          );
                        }
                      } else {
                        showActionWithoutRecurringBuy(
                          title: intl.actionBuy_actionWithOutRecurringBuyTitle1,
                          context: context,
                          onItemTap: (RecurringBuysType type) {
                            navigatorPushReplacement(
                              context,
                              CurrencyBuy(
                                currency: widget.currency,
                                fromCard: false,
                                recurringBuysType: type,
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      sAnalytics.setupRecurringBuyView(
                        widget.currency.description,
                        Source.walletDetails,
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
              ),
            SliverToBoxAdapter(
              child: SPaddingH24(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH36(),
                    Text(
                      '${widget.currency.description}'
                          ' ${intl.walletBody_transactions}',
                      style: sTextH4Style,
                    ),
                  ],
                ),
              ),
            ),
            TransactionsList(
              scrollController: _scrollController,
              symbol: widget.currency.symbol,
            ),
          ],
        ),
      ),
    );
  }

  void _snapAppbar() {
    const scrollDistance = _expandedCardHeight - _collapsedCardHeight;

    if (_scrollController.offset > 0 &&
        _scrollController.offset < scrollDistance) {
      final snapOffset =
          _scrollController.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(
        () => _scrollController.animateTo(
          snapOffset.toDouble(),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
