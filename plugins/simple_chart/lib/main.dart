import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import './simple_chart.dart';
import 'components/loading_chart_view.dart';
import 'components/resolution_button.dart';

bool showAnimation = false;

class Chart extends StatefulWidget {
  const Chart({
    Key? key,
    required this.onResolutionChanged,
    required this.onChartTypeChanged,
    required this.onCandleSelected,
    required this.formatPrice,
    required this.candles,
    required this.candleResolution,
    required this.chartHeight,
    required this.chartWidgetHeight,
    required this.isAssetChart,
    required this.loader,
    required this.localizedChartResolutionButton,
    this.chartType = ChartType.line,
    this.walletCreationDate,
    this.selectedCandlePadding,
  }) : super(key: key);

  final void Function(String) onResolutionChanged;
  final void Function(ChartType) onChartTypeChanged;
  final void Function(ChartInfoModel?) onCandleSelected;
  final String Function({
    String? prefix,
    required Decimal decimal,
    required int accuracy,
    required String symbol,
  }) formatPrice;
  final List<CandleModel>? candles;
  final ChartType chartType;
  final String candleResolution;
  final String? walletCreationDate;
  final double? selectedCandlePadding;
  final double chartHeight;
  final double chartWidgetHeight;
  final bool isAssetChart;
  final Widget loader;
  final List<String> localizedChartResolutionButton;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(5.0, 0.0),
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    ),
  );
  ChartInfoModel? _chartInfo;

  @override
  void initState() {
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final chartWidth = screenWidth - 24;
    var candleWidth = 0.0;
    if (widget.candles != null) {
      candleWidth = chartWidth / widget.candles!.length;
    }

    final currentDate = DateTime.now().toLocal();
    final localCreationDate = widget.walletCreationDate == null
        ? currentDate
        : DateTime.parse('${widget.walletCreationDate}').toLocal();
    bool showWeek;
    bool showMonth;
    bool showYear;
    if (localCreationDate == currentDate) {
      showWeek = true;
      showMonth = true;
      showYear = true;
    } else {
      final dateDifference = currentDate.difference(localCreationDate).inHours;
      showWeek = dateDifference > const Duration(days: 7).inHours;
      showMonth = dateDifference > const Duration(days: 30).inHours;
      showYear = dateDifference > const Duration(days: 365).inHours;
    }

    if (showAnimation) {
      animationController.reset();
      animationController.forward();
      showAnimation = false;
    }

    if (widget.candles == null || widget.candles!.isEmpty) {
      return LoadingChartView(
        height: widget.chartWidgetHeight,
        showLoader: widget.candles == null,
        resolution: widget.candleResolution,
        localizedChartResolutionButton: widget.localizedChartResolutionButton,
        loader: widget.loader,
        onResolutionChanged: widget.onResolutionChanged,
        showWeek: showWeek,
        showMonth: showMonth,
        showYear: showYear,
        isBalanceChart: !widget.isAssetChart,
      );
    } else {
      return SizedBox(
        height: widget.chartWidgetHeight,
        width: screenWidth,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              SizedBox(
                height: widget.chartHeight,
                width: screenWidth,
                child: Stack(
                  children: [
                    KChartWidget(
                      widget.candles ?? [],
                      candleType: widget.chartType,
                      candleWidth: candleWidth,
                      candleResolution: widget.candleResolution,
                      onCandleSelected: (ChartInfoModel? chartInfo) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _chartInfo = chartInfo;
                          widget.onCandleSelected(_chartInfo);

                          setState(() {
                            _chartInfo = chartInfo;
                            widget.onCandleSelected(_chartInfo);
                          });
                        });
                      },
                      formatPrice: widget.formatPrice,
                      selectedCandlePadding: widget.selectedCandlePadding,
                      isAssetChart: widget.isAssetChart,
                      chartWidth: chartWidth,
                    ),
                    SlideTransition(
                      position: _offsetAnimation,
                      child: Container(
                        color: Colors.white,
                        height: widget.isAssetChart ? 230 : 190,
                        width: screenWidth,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 37,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResolutionButton(
                      text: '1${widget.localizedChartResolutionButton[0]}',
                      showUnderline: widget.candleResolution == Period.day,
                      onTap: widget.candleResolution == Period.day
                          ? null
                          : () {
                              widget.onResolutionChanged(Period.day);
                            },
                    ),
                    if (showWeek)
                      ResolutionButton(
                        text: '1${widget.localizedChartResolutionButton[1]}',
                        showUnderline: widget.candleResolution == Period.week,
                        onTap: widget.candleResolution == Period.week
                            ? null
                            : () {
                                widget.onResolutionChanged(Period.week);
                              },
                      ),
                    if (showMonth)
                      ResolutionButton(
                        text: '1${widget.localizedChartResolutionButton[2]}',
                        showUnderline: widget.candleResolution == Period.month,
                        onTap: widget.candleResolution == Period.month
                            ? null
                            : () {
                                widget.onResolutionChanged(Period.month);
                              },
                      ),
                    if (showYear)
                      ResolutionButton(
                        text: '1${widget.localizedChartResolutionButton[3]}',
                        showUnderline: widget.candleResolution == Period.year,
                        onTap: widget.candleResolution == Period.year
                            ? null
                            : () {
                                widget.onResolutionChanged(Period.year);
                              },
                      ),
                    ResolutionButton(
                      text: widget.localizedChartResolutionButton[4],
                      showUnderline: widget.candleResolution == Period.all,
                      onTap: widget.candleResolution == Period.all
                          ? null
                          : () {
                              widget.onResolutionChanged(Period.all);
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
