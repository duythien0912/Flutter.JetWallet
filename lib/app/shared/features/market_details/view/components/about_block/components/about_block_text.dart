import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../service/services/market_info/model/market_info_response_model.dart';
import '../../../../../../../../shared/helpers/launch_url.dart';
import 'clickable_underlined_text.dart';

class AboutBlockText extends StatefulHookWidget {
  const AboutBlockText({
    Key? key,
    required this.marketInfo,
    required this.showDivider,
  }) : super(key: key);

  final MarketInfoResponseModel marketInfo;
  final bool showDivider;

  @override
  State<AboutBlockText> createState() => _AboutBlockTextState();
}

class _AboutBlockTextState extends State<AboutBlockText>
    with WidgetsBindingObserver {
  bool canTapOnLink = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        canTapOnLink = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final expandText = useState(false);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.marketInfo.aboutLess.isNotEmpty)
            Text(
              expandText.value
                  ? widget.marketInfo.aboutMore
                  : widget.marketInfo.aboutLess,
              maxLines: expandText.value ? 10 : 4,
              style: sBodyText1Style.copyWith(color: Colors.black),
            ),
          if (!expandText.value && widget.marketInfo.aboutLess.isNotEmpty) ...[
            const SpaceH18(),
            ClickableUnderlinedText(
              text: 'Read more',
              onTap: () => expandText.value = !expandText.value,
            ),
          ],
          if (_urlValid(widget.marketInfo.whitepaperUrl)) ...[
            if (widget.marketInfo.aboutLess.isNotEmpty) const SpaceH13(),
            ClickableUnderlinedText(
              text: 'Whitepaper',
              onTap: () {
                if (canTapOnLink) {
                  setState(() {
                    canTapOnLink = false;
                  });
                  launchURL(context, widget.marketInfo.whitepaperUrl!);
                }
              },
            ),
          ],
          if (_urlValid(widget.marketInfo.officialWebsiteUrl)) ...[
            const SpaceH13(),
            ClickableUnderlinedText(
              text: 'Official website',
              onTap: () {
                if (canTapOnLink) {
                  setState(() {
                    canTapOnLink = false;
                  });
                  launchURL(context, widget.marketInfo.officialWebsiteUrl!);
                }
              },
            ),
          ],
          const SpaceH33(),
          if (widget.showDivider) const SDivider(),
        ],
      ),
    );
  }

  bool _urlValid(String? url) => url != null && url.isNotEmpty;
}
