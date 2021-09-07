import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../shared/helpers/navigator_push.dart';
import '../../components/action_sheet_button.dart';
import '../../components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../convert/view/convert.dart';
import 'actions/action_buy/action_buy.dart';
import 'actions/action_deposit/action_deposit.dart';
import 'actions/action_receive/action_receive.dart';
import 'actions/action_sell/action_sell.dart';
import 'actions/action_withdraw/action_withdraw.dart';

void showNavigationAction(BuildContext context, AppLocalizations intl) {
  showBasicBottomSheet(
    context: context,
    children: [
      ActionSheetButton(
        title: intl.buy,
        description: intl.buyCryptoWithYourLocalCurrency,
        icon: FontAwesomeIcons.plus,
        onTap: () => navigatorPush(context, const ActionBuy()),
      ),
      ActionSheetButton(
        title: intl.sell,
        description: intl.sellCryptoToYourLocalCurrency,
        icon: FontAwesomeIcons.minus,
        onTap: () => navigatorPush(context, const ActionSell()),
      ),
      ActionSheetButton(
        title: intl.convert,
        description: intl.quicklySwapOneCryptoForAnother,
        icon: FontAwesomeIcons.exchangeAlt,
        onTap: () => navigatorPush(context, const Convert()),
      ),
      ActionSheetButton(
        title: intl.deposit,
        description: intl.depositWithFiat,
        icon: FontAwesomeIcons.creditCard,
        onTap: () => navigatorPush(context, const ActionDeposit()),
      ),
      ActionSheetButton(
        title: intl.withdraw,
        description: intl.withdrawCryptoToYourCreditCard,
        icon: FontAwesomeIcons.arrowRight,
        onTap: () => navigatorPush(context, const ActionWithdraw()),
      ),
      ActionSheetButton(
        title: intl.send,
        description: intl.sendCryptoToAnotherWallet,
        icon: FontAwesomeIcons.arrowUp,
        onTap: () => navigatorPush(context, const ActionWithdraw()),
      ),
      ActionSheetButton(
        title: intl.receive,
        description: intl.receiveCryptoFromAnotherWallet,
        icon: FontAwesomeIcons.arrowDown,
        onTap: () => navigatorPush(context, const ActionReceive()),
      ),
    ],
  );
}
