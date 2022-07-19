enum Flavor {
  dev,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Leash (Dev)';
      default:
        return 'Leash';
    }
  }
}