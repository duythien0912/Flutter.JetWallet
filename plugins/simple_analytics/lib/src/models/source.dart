/// Source screens, used to indicate from what place user navigated
enum Source {
  emptyPorfolioScreen,
  emptyWalletScreen,
  rewards,
  marketBanner,
}

extension SourceExtension on Source {
  String get name {
    switch (this) {
      case Source.emptyPorfolioScreen:
        return 'Empty portfolio screen';
      case Source.emptyWalletScreen:
        return 'Empty wallet';
      case Source.rewards:
        return 'Rewards';
      case Source.marketBanner:
        return 'Market banner';
    }
  }
}
