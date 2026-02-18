import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

const String _settingsKey = 'app_settings';

class SettingsState extends ChangeNotifier {
  AppSettings _settings = AppSettings.defaultSettings();

  AppSettings get settings => _settings;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_settingsKey);
    if (jsonStr != null) {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      _settings = AppSettings.fromJson(map);
      notifyListeners();
    }
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(_settings.toJson()));
  }

  void updateTier(SubscriptionTier tier) {
    final bool allowPrivateBudget;
    final bool allowGpsTracking;
    final bool allowVoiceCommands;
    final int exportLimit;
    switch (tier) {
      case SubscriptionTier.basic:
        allowPrivateBudget = false;
        allowGpsTracking = false;
        allowVoiceCommands = false;
        exportLimit = 3;
        break;
      case SubscriptionTier.advance:
        allowPrivateBudget = true;
        allowGpsTracking = true;
        allowVoiceCommands = false;
        exportLimit = 50;
        break;
      case SubscriptionTier.pro:
        allowPrivateBudget = true;
        allowGpsTracking = true;
        allowVoiceCommands = true;
        exportLimit = 9999;
        break;
    }
    _settings = AppSettings(
      subscriptionTier: tier,
      vatPercentage: _settings.vatPercentage,
      currencyCode: _settings.currencyCode,
      exportCountThisMonth: _settings.exportCountThisMonth,
      exportLimit: exportLimit,
      aaRatePerKm: _settings.aaRatePerKm,
      vehicles: _settings.vehicles,
      allowPrivateBudget: allowPrivateBudget,
      allowGpsTracking: allowGpsTracking,
      allowVoiceCommands: allowVoiceCommands,
    );
    notifyListeners();
  }

  void updateVat(double vat) {
    _settings = AppSettings(
      subscriptionTier: _settings.subscriptionTier,
      vatPercentage: vat,
      currencyCode: _settings.currencyCode,
      exportCountThisMonth: _settings.exportCountThisMonth,
      exportLimit: _settings.exportLimit,
      aaRatePerKm: _settings.aaRatePerKm,
      vehicles: _settings.vehicles,
      allowPrivateBudget: _settings.allowPrivateBudget,
      allowGpsTracking: _settings.allowGpsTracking,
      allowVoiceCommands: _settings.allowVoiceCommands,
    );
    notifyListeners();
  }

  void updateCurrency(String currency) {
    _settings = AppSettings(
      subscriptionTier: _settings.subscriptionTier,
      vatPercentage: _settings.vatPercentage,
      currencyCode: currency,
      exportCountThisMonth: _settings.exportCountThisMonth,
      exportLimit: _settings.exportLimit,
      aaRatePerKm: _settings.aaRatePerKm,
      vehicles: _settings.vehicles,
      allowPrivateBudget: _settings.allowPrivateBudget,
      allowGpsTracking: _settings.allowGpsTracking,
      allowVoiceCommands: _settings.allowVoiceCommands,
    );
    notifyListeners();
  }

  void incrementExportCount() {
    final newCount = _settings.exportCountThisMonth + 1;
    final capped = newCount > _settings.exportLimit ? _settings.exportLimit : newCount;
    _settings = AppSettings(
      subscriptionTier: _settings.subscriptionTier,
      vatPercentage: _settings.vatPercentage,
      currencyCode: _settings.currencyCode,
      exportCountThisMonth: capped,
      exportLimit: _settings.exportLimit,
      aaRatePerKm: _settings.aaRatePerKm,
      vehicles: _settings.vehicles,
      allowPrivateBudget: _settings.allowPrivateBudget,
      allowGpsTracking: _settings.allowGpsTracking,
      allowVoiceCommands: _settings.allowVoiceCommands,
    );
    notifyListeners();
  }

  void resetMonthlyExportCount() {
    _settings = AppSettings(
      subscriptionTier: _settings.subscriptionTier,
      vatPercentage: _settings.vatPercentage,
      currencyCode: _settings.currencyCode,
      exportCountThisMonth: 0,
      exportLimit: _settings.exportLimit,
      aaRatePerKm: _settings.aaRatePerKm,
      vehicles: _settings.vehicles,
      allowPrivateBudget: _settings.allowPrivateBudget,
      allowGpsTracking: _settings.allowGpsTracking,
      allowVoiceCommands: _settings.allowVoiceCommands,
    );
    notifyListeners();
  }

  void updateAaRate(double rate) {
    _settings = AppSettings(
      subscriptionTier: _settings.subscriptionTier,
      vatPercentage: _settings.vatPercentage,
      currencyCode: _settings.currencyCode,
      exportCountThisMonth: _settings.exportCountThisMonth,
      exportLimit: _settings.exportLimit,
      aaRatePerKm: rate,
      vehicles: _settings.vehicles,
      allowPrivateBudget: _settings.allowPrivateBudget,
      allowGpsTracking: _settings.allowGpsTracking,
      allowVoiceCommands: _settings.allowVoiceCommands,
    );
    notifyListeners();
  }
}
