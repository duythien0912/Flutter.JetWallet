import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import '../../../../../../../provider/contact_name_for_phone_fpod.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class ReceiveDetails extends HookWidget {
  const ReceiveDetails({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final contactName = useProvider(
      contactNameForPhoneFpod(
        transactionListItem.receiveByPhoneInfo!.fromPhoneNumber,
      ),
    );

    return Column(
      children: [
        TransactionDetailsItem(
          text: 'Transaction ID',
          value: TransactionDetailsValueText(
            text: shortAddressForm(transactionListItem.operationId),
          ),
        ),
        const SpaceH10(),
        TransactionDetailsItem(
          text: 'Transfer from',
          value: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TransactionDetailsValueText(
                text:
                    '+${transactionListItem
                        .receiveByPhoneInfo!.fromPhoneNumber}',
              ),
              contactName.when(
                data: (String? contactName) {
                  if (contactName != null) {
                    return Text(
                      contactName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  } else if (transactionListItem
                      .receiveByPhoneInfo!.senderName.isNotEmpty) {
                    return Text(
                      transactionListItem.receiveByPhoneInfo!.senderName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
