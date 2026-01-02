/// Currency helper utility for formatting and displaying currencies
class CurrencyHelper {
  static const Map<String, CurrencyInfo> currencies = {
    'NGN': CurrencyInfo(code: 'NGN', symbol: '₦', name: 'Nigerian Naira'),
    'USD': CurrencyInfo(code: 'USD', symbol: '\$', name: 'US Dollar'),
    'EUR': CurrencyInfo(code: 'EUR', symbol: '€', name: 'Euro'),
    'GBP': CurrencyInfo(code: 'GBP', symbol: '£', name: 'British Pound'),
    'GHS': CurrencyInfo(code: 'GHS', symbol: 'GH₵', name: 'Ghanaian Cedi'),
    'KES': CurrencyInfo(code: 'KES', symbol: 'KSh', name: 'Kenyan Shilling'),
    'ZAR': CurrencyInfo(code: 'ZAR', symbol: 'R', name: 'South African Rand'),
    'XOF': CurrencyInfo(code: 'XOF', symbol: 'CFA', name: 'West African CFA Franc'),
  };

  /// Get currency symbol from code
  static String getSymbol(String currencyCode) {
    return currencies[currencyCode]?.symbol ?? currencyCode;
  }

  /// Format price with currency symbol
  static String formatPrice(double price, String currencyCode) {
    final symbol = getSymbol(currencyCode);
    return '$symbol${price.toStringAsFixed(2)}';
  }

  /// Get all available currency codes
  static List<String> get availableCurrencies => currencies.keys.toList();

  /// Get currency info by code
  static CurrencyInfo? getCurrencyInfo(String code) => currencies[code];
}

class CurrencyInfo {
  final String code;
  final String symbol;
  final String name;

  const CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.name,
  });

  @override
  String toString() => '$name ($symbol)';
}
