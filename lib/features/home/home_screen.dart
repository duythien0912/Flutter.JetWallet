import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/home/widgets/bottom_navigation_menu.dart';
import 'package:simple_kit/modules/bottom_sheets/components/simple_shade_animation_stack.dart';

List<PageRouteInfo<dynamic>> screens = [];

List<PageRouteInfo<dynamic>> screensWithNews = const [
  MarketRouter(),
  PortfolioRouter(),
  NewsRouter(),
  AccountRouter(),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final bool earnEnabled = false;

  late AnimationController animationController;

  void animationListener() {}

  @override
  void initState() {
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    animationController.addListener(animationListener);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: earnEnabled ? screens : screensWithNews,
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationMenu(
          transitionAnimationController: animationController,
          currentIndex: tabsRouter.activeIndex,
          onChanged: tabsRouter.setActiveIndex,
        );
      },
    );
  }
}
