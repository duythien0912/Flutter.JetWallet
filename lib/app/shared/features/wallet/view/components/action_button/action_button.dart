import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../models/currency_model.dart';
import '../../../../actions/action_deposit/components/deposit_options.dart';
import '../../../../actions/action_send/components/send_options.dart';
import '../../../../actions/action_withdraw/components/withdraw_options.dart';
import '../../../../convert/view/convert.dart';
import '../../../../crypto_deposit/view/crypto_deposit.dart';
import '../../../../currency_buy/view/curency_buy.dart';
import '../../../../currency_sell/view/currency_sell.dart';

const _expandInterval = Interval(
  0.0,
  0.5,
  curve: Cubic(0.42, 0, 0, 0.99),
);

const _narrowInterval = Interval(
  0.5,
  1.0,
  curve: Cubic(1, 0, 0.58, 1),
);

class ActionButton extends StatefulHookWidget {
  const ActionButton({
    Key? key,
    required this.transitionAnimationController,
    required this.currency,
  }) : super(key: key);

  final AnimationController transitionAnimationController;
  final CurrencyModel currency;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final actionActive = useState(true);
    final highlighted = useState(false);
    final isDepositAvailable =
        widget.currency.supportsAtLeastOneFiatDepositMethod ||
            widget.currency.supportsCryptoDeposit;

    void updateActionState() => actionActive.value = !actionActive.value;

    final scaleAnimation = Tween(
      begin: 0.0,
      end: 80.0,
    ).animate(
      CurvedAnimation(
        parent: widget.transitionAnimationController,
        curve: Curves.linear,
      ),
    );

    late Color currentNameColor;

    if (highlighted.value) {
      currentNameColor = colors.white.withOpacity(0.8);
    } else {
      currentNameColor = colors.white;
    }

    return Material(
      color: colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (scaleAnimation.value == 0) const SDivider(),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
              top: 23,
            ),
            child: AnimatedContainer(
              width:
                  actionActive.value ? MediaQuery.of(context).size.width : 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: actionActive.value
                    ? BorderRadius.circular(16)
                    : BorderRadius.circular(100),
              ),
              duration: const Duration(milliseconds: 300),
              curve: actionActive.value
                  ? const Cubic(0.42, 0, 0, 0.99)
                  : const Cubic(1, 0, 0.58, 1),
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: actionActive.value ? 1 : 0,
                    duration:
                        Duration(milliseconds: actionActive.value ? 150 : 300),
                    curve: actionActive.value
                        ? _expandInterval
                        : _narrowInterval,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onHighlightChanged: (value) {
                        highlighted.value = value;
                      },
                      child: Center(
                        child: Text(
                          actionActive.value ? 'Action' : '',
                          style: sButtonTextStyle.copyWith(
                            color: currentNameColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (actionActive.value) {
                          sShowMenuActionSheet(
                            context: context,
                            isNotEmptyBalance:
                                widget.currency.isAssetBalanceNotEmpty,
                            isDepositAvailable: isDepositAvailable,
                            isWithdrawAvailable: widget
                                .currency.supportsAtLeastOneWithdrawalMethod,
                            isSendAvailable:
                                widget.currency.supportsCryptoWithdrawal,
                            isReceiveAvailable:
                                widget.currency.supportsCryptoDeposit,
                            onBuy: () {
                              navigatorPushReplacement(
                                context,
                                CurrencyBuy(
                                  currency: widget.currency,
                                ),
                              );
                            },
                            onSell: () {
                              navigatorPushReplacement(
                                context,
                                CurrencySell(
                                  currency: widget.currency,
                                ),
                              );
                            },
                            onConvert: () {
                              navigatorPush(
                                context,
                                Convert(
                                  fromCurrency: widget.currency,
                                ),
                              );
                            },
                            onDeposit: () {
                              if (widget.currency.type == AssetType.fiat) {
                                showDepositOptions(
                                  context,
                                  widget.currency,
                                );
                              } else {
                                navigatorPushReplacement(
                                  context,
                                  CryptoDeposit(
                                    header: 'Deposit',
                                    currency: widget.currency,
                                  ),
                                );
                              }
                            },
                            onWithdraw: () {
                              showWithdrawOptions(context, widget.currency);
                            },
                            onSend: () {
                              showSendOptions(context, widget.currency);
                            },
                            onReceive: () {
                              navigatorPushReplacement(
                                context,
                                CryptoDeposit(
                                  header: 'Receive',
                                  currency: widget.currency,
                                ),
                              );
                            },
                            onDissmis: updateActionState,
                            whenComplete: () {
                              if (!actionActive.value) updateActionState();
                            },
                            transitionAnimationController:
                                widget.transitionAnimationController,
                          );
                        } else {
                          Navigator.pop(context);
                        }
                        updateActionState();
                      },
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: actionActive.value ? 0 : 1,
                    duration:
                        Duration(milliseconds: actionActive.value ? 300 : 150),
                    curve: actionActive.value
                        ? _expandInterval
                        : _narrowInterval,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onHighlightChanged: (value) {
                        highlighted.value = value;
                      },
                      child: Center(
                        child: highlighted.value
                            ? const SActionActiveHighlightedIcon()
                            : const SActionActiveIcon(),
                      ),
                      onTap: () {
                        if (actionActive.value) {
                          sShowMenuActionSheet(
                            context: context,
                            isNotEmptyBalance:
                                widget.currency.isAssetBalanceNotEmpty,
                            isDepositAvailable: isDepositAvailable,
                            isWithdrawAvailable: widget
                                .currency.supportsAtLeastOneWithdrawalMethod,
                            isSendAvailable:
                                widget.currency.supportsCryptoWithdrawal,
                            isReceiveAvailable:
                                widget.currency.supportsCryptoDeposit,
                            onBuy: () {
                              navigatorPushReplacement(
                                context,
                                CurrencyBuy(
                                  currency: widget.currency,
                                ),
                              );
                            },
                            onSell: () {
                              navigatorPushReplacement(
                                context,
                                CurrencySell(
                                  currency: widget.currency,
                                ),
                              );
                            },
                            onConvert: () {
                              navigatorPush(
                                context,
                                Convert(
                                  fromCurrency: widget.currency,
                                ),
                              );
                            },
                            onDeposit: () {
                              if (widget.currency.type == AssetType.fiat) {
                                showDepositOptions(
                                  context,
                                  widget.currency,
                                );
                              } else {
                                navigatorPushReplacement(
                                  context,
                                  CryptoDeposit(
                                    header: 'Deposit',
                                    currency: widget.currency,
                                  ),
                                );
                              }
                            },
                            onWithdraw: () {
                              showWithdrawOptions(context, widget.currency);
                            },
                            onSend: () {
                              showSendOptions(context, widget.currency);
                            },
                            onReceive: () {
                              navigatorPushReplacement(
                                context,
                                CryptoDeposit(
                                  header: 'Receive',
                                  currency: widget.currency,
                                ),
                              );
                            },
                            onDissmis: updateActionState,
                            whenComplete: () {
                              if (!actionActive.value) updateActionState();
                            },
                            transitionAnimationController:
                                widget.transitionAnimationController,
                          );
                        } else {
                          Navigator.pop(context);
                        }
                        updateActionState();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
