import '../models/unit.dart';

class UnitConverter {
  /// Converts a length value from [fromUnit] to meters.
  static double lengthToMeters(double value, LengthUnit fromUnit) {
    return value * fromUnit.metersFactor;
  }

  /// Converts a length value from meters to [toUnit].
  static double metersToLength(double meters, LengthUnit toUnit) {
    return meters / toUnit.metersFactor;
  }

  /// Converts an area value from square meters (m²) to [toAreaUnit].
  static double squareMetersToArea(double sqMeters, AreaUnit toAreaUnit) {
    return sqMeters / toAreaUnit.squareMetersFactor;
  }

  /// Formats double values cleanly without unnecessary decimal places or exponent noise
  static String formatNumber(double val, {int maxDecimals = 4}) {
    if (val.isNaN || val.isInfinite) return 'Invalid';
    
    // If integer or very close to integer
    if ((val - val.roundToDouble()).abs() < 1e-9) {
      return val.round().toString();
    }

    String formatted = val.toStringAsFixed(maxDecimals);
    // Remove trailing zeros after decimal point
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }
    return formatted;
  }
}
