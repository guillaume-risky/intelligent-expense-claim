enum SubscriptionTier {
  basic,
  advance,
  pro,
}

class AppSettings {
  final SubscriptionTier subscriptionTier;
  final double vatPercentage;
  final String currencyCode;
  final int exportCountThisMonth;
  final int exportLimit;
  final double aaRatePerKm;
  final List<String> vehicles;
  final bool allowPrivateBudget;
  final bool allowGpsTracking;
  final bool allowVoiceCommands;

  AppSettings({
    required this.subscriptionTier,
    required this.vatPercentage,
    required this.currencyCode,
    required this.exportCountThisMonth,
    required this.exportLimit,
    required this.aaRatePerKm,
    required this.vehicles,
    required this.allowPrivateBudget,
    required this.allowGpsTracking,
    required this.allowVoiceCommands,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings(
      subscriptionTier: SubscriptionTier.basic,
      vatPercentage: 15,
      currencyCode: "ZAR",
      exportCountThisMonth: 0,
      exportLimit: 3,
      aaRatePerKm: 4.84,
      vehicles: [],
      allowPrivateBudget: false,
      allowGpsTracking: false,
      allowVoiceCommands: false,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['subscriptionTier'],
        orElse: () => SubscriptionTier.basic,
      ),
      vatPercentage: (json['vatPercentage'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      exportCountThisMonth: json['exportCountThisMonth'] as int,
      exportLimit: json['exportLimit'] as int,
      aaRatePerKm: (json['aaRatePerKm'] as num).toDouble(),
      vehicles: List<String>.from(json['vehicles'] as List? ?? []),
      allowPrivateBudget: json['allowPrivateBudget'] as bool? ?? false,
      allowGpsTracking: json['allowGpsTracking'] as bool? ?? false,
      allowVoiceCommands: json['allowVoiceCommands'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptionTier': subscriptionTier.name,
      'vatPercentage': vatPercentage,
      'currencyCode': currencyCode,
      'exportCountThisMonth': exportCountThisMonth,
      'exportLimit': exportLimit,
      'aaRatePerKm': aaRatePerKm,
      'vehicles': vehicles,
      'allowPrivateBudget': allowPrivateBudget,
      'allowGpsTracking': allowGpsTracking,
      'allowVoiceCommands': allowVoiceCommands,
    };
  }
}
