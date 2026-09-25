import 'dart:math' as math;
import '../models/calculator_type.dart';
import '../models/calculation_result.dart';
import '../models/unit.dart';
import '../services/unit_converter.dart';

abstract class ShapeCalculator {
  /// Validates string inputs. Returns an error message if invalid, or null if valid.
  static String? validateInputs(ShapeType type, Map<String, String> rawInputs) {
    final config = ShapeConfig.findByType(type);

    for (var spec in config.inputs) {
      final text = rawInputs[spec.key]?.trim() ?? '';
      if (text.isEmpty) {
        return 'Please enter a value for ${spec.label}.';
      }

      final val = double.tryParse(text);
      if (val == null) {
        return 'Please enter a valid number for ${spec.label}.';
      }

      if (val <= 0) {
        return '${spec.label} must be greater than zero.';
      }
    }

    // Special shape specific validations
    if (type == ShapeType.sphericalCap) {
      final R = double.parse(rawInputs['sphereRadius']!);
      final h = double.parse(rawInputs['height']!);
      if (h > 2 * R) {
        return 'Cap height (h) cannot exceed sphere diameter (2R = ${UnitConverter.formatNumber(2 * R)}).';
      }
    }

    return null;
  }

  /// Calculates surface area from validated raw inputs and their respective length units.
  static CalculationResult calculate(
    ShapeType type,
    Map<String, String> rawInputs,
    Map<String, LengthUnit> inputUnits,
  ) {
    final config = ShapeConfig.findByType(type);
    
    // Normalize all input values to base unit (Meters)
    final Map<String, double> inMeters = {};
    final Map<String, String> formattedInputs = {};

    for (var spec in config.inputs) {
      final rawVal = double.parse(rawInputs[spec.key]!);
      final unit = inputUnits[spec.key] ?? spec.defaultUnit;
      final metersVal = UnitConverter.lengthToMeters(rawVal, unit);
      inMeters[spec.key] = metersVal;
      formattedInputs[spec.label] = '${UnitConverter.formatNumber(rawVal)} ${unit.symbol}';
    }

    switch (type) {
      case ShapeType.sphere:
        return _calculateSphere(inMeters, formattedInputs);
      case ShapeType.cone:
        return _calculateCone(inMeters, formattedInputs);
      case ShapeType.cube:
        return _calculateCube(inMeters, formattedInputs);
      case ShapeType.cylinder:
        return _calculateCylinder(inMeters, formattedInputs);
      case ShapeType.cuboid:
        return _calculateCuboid(inMeters, formattedInputs);
      case ShapeType.capsule:
        return _calculateCapsule(inMeters, formattedInputs);
      case ShapeType.sphericalCap:
        return _calculateSphericalCap(inMeters, formattedInputs);
      case ShapeType.frustum:
        return _calculateFrustum(inMeters, formattedInputs);
      case ShapeType.ellipsoid:
        return _calculateEllipsoid(inMeters, formattedInputs);
    }
  }

  static CalculationResult _calculateSphere(
    Map<String, double> inM,
    Map<String, String> formattedInputs,
  ) {
    final r = inM['radius']!;
    final area = 4 * math.pi * r * r;
    return CalculationResult(
      surfaceAreaInSqMeters: area,
      formula: 'A = 4 × π × r²',
      inputsFormatted: formattedInputs,
    );
  }

  static CalculationResult _calculateCone(
    Map<String, double> inM,
    Map<String, String> formattedInputs,
  ) {
    final r = inM['radius']!;
    final h = inM['height']!;
    final l = math.sqrt(r * r + h * h);
    final area = math.pi * r * (r + l);

    return CalculationResult(
      surfaceAreaInSqMeters: area,
      formula: 'A = πr(r + l) where l = √(r² + h²)',
      inputsFormatted: formattedInputs,
      extraDetails: {
        'Slant Height (l)': '${UnitConverter.formatNumber(l)} m',
        'Base Area (πr²)': '${UnitConverter.formatNumber(math.pi * r * r)} m²',
        'Lateral Area (πrl)': '${UnitConverter.formatNumber(math.pi * r * l)} m²',
      },
    );
  }

  static CalculationResult _calculateCube(
    Map<String, double> inM,
    Map<String, String> formattedInputs,
  ) {
    final a = inM['edge']!;
    final area = 6 * a * a;
    return CalculationResult(
      surfaceAreaInSqMeters: area,
      formula: 'A = 6 × a²',
      inputsFormatted: formattedInputs,
      extraDetails: {
        'Face Area (a²)': '${UnitConverter.formatNumber(a * a)} m²',
      },
    );
  }

  static CalculationResult _calculateCylinder(
    Map<String, double> inM,
    Map<String, String> formattedInputs,
  ) {
    final r = inM['radius']!;
    final h = inM['height']!;
    final baseArea = 2 * math.pi * r * r; // Top + Bottom
    final lateralArea = 2 * math.pi * r * h;
    final totalArea = baseArea + lateralArea;

    return CalculationResult(
      surfaceAreaInSqMeters: totalArea,
      formula: 'A = 2πr(r + h) [Closed Cylinder]',
      inputsFormatted: formattedInputs,
      extraDetails: {
        'Top & Bottom Base Area (2πr²)': '${UnitConverter.formatNumber(baseArea)} m²',
        'Lateral Wall Area (2πrh)': '${UnitConverter.formatNumber(lateralArea)} m²',
      },
    );
  }

  static CalculationResult _calculateCuboid(
    Map<String, double> inM,
    Map<String, String> formattedInputs,
  ) {
    final l = inM['length']!;
    final w = inM['width']!;
    final h = inM['height']!;
    final area = 2 * (l * w + l * h + w * h);

    return CalculationResult(
      surfaceAreaInSqMeters: area,
      formula: 'A = 2(l×w + l×h + w×h)',
      inputsFormatted: formattedInputs,
      extraDetails: {
        'Top & Bottom Area (2lw)': '${UnitConverter.formatNumber(2 * l * w)} m²',
        'Front & Back Area (2lh)': '${UnitConverter.formatNumber(2 * l * h)} m²',
        'Side Faces Area (2wh)': '${UnitConverter.formatNumber(2 * w * h)} m²',
      },
    );
  }

  static CalculationResult _calculateCapsule(
    Map<String, double> inM,
    Map<String, String> formattedInputs,
  ) {
    final r = inM['radius']!;
    final h = inM['height']!;
    final sphereCapArea = 4 * math.pi * r * r;
    final cylinderWallArea = 2 * math.pi * r * h;
    final totalArea = sphereCapArea + cylinderWallArea;

    return CalculationResult(
      surfaceAreaInSqMeters: totalArea,
      formula: 'A = 4πr² + 2πrh',
      inputsFormatted: formattedInputs,
      extraDetails: {
        'End Hemispheres Area (4πr²)': '${UnitConverter.formatNumber(sphereCapArea)} m²',
        'Middle Cylinder Wall Area (2πrh)': '${UnitConverter.formatNumber(cylinderWallArea)} m²',
      },
    );
  }

  static CalculationResult _calculateSphericalCap(
    Map<String, double> inM,
    Map<String, String> formattedInputs,
  ) {
    final R = inM['sphereRadius']!;
    final h = inM['height']!;
    
    // Base radius of cap
    final a = math.sqrt(math.max(0, 2 * R * h - h * h));
    final curvedArea = 2 * math.pi * R * h;
    final baseArea = math.pi * a * a;
    final totalArea = curvedArea + baseArea;

    return CalculationResult(
      surfaceAreaInSqMeters: totalArea,
      formula: 'Curved Area = 2πRh | Total Area = 2πRh + πa²',
      inputsFormatted: formattedInputs,
      extraDetails: {
        'Curved Surface Area (2πRh)': '${UnitConverter.formatNumber(curvedArea)} m²',
        'Base Surface Area (πa²)': '${UnitConverter.formatNumber(baseArea)} m²',
        'Derived Base Radius (a)': '${UnitConverter.formatNumber(a)} m',
      },
      note: 'Primary result is Total Surface Area (curved + flat base). Curved area alone is ${UnitConverter.formatNumber(curvedArea)} m².',
    );
  }

  static CalculationResult _calculateFrustum(
    Map<String, double> inM,
    Map<String, String> formattedInputs,
  ) {
    final r = inM['topRadius']!;
    final R = inM['bottomRadius']!;
    final h = inM['height']!;

    final l = math.sqrt((R - r) * (R - r) + h * h);
    final topArea = math.pi * r * r;
    final bottomArea = math.pi * R * R;
    final lateralArea = math.pi * (R + r) * l;
    final totalArea = lateralArea + topArea + bottomArea;

    return CalculationResult(
      surfaceAreaInSqMeters: totalArea,
      formula: 'A = π(R + r)l + πR² + πr²',
      inputsFormatted: formattedInputs,
      extraDetails: {
        'Slant Height (l)': '${UnitConverter.formatNumber(l)} m',
        'Top Base Area (πr²)': '${UnitConverter.formatNumber(topArea)} m²',
        'Bottom Base Area (πR²)': '${UnitConverter.formatNumber(bottomArea)} m²',
        'Lateral Wall Area (π(R+r)l)': '${UnitConverter.formatNumber(lateralArea)} m²',
      },
    );
  }

  static CalculationResult _calculateEllipsoid(
    Map<String, double> inM,
    Map<String, String> formattedInputs,
  ) {
    final a = inM['axisA']!;
    final b = inM['axisB']!;
    final c = inM['axisC']!;

    // Knud Thomsen formula with p = 1.6075
    const p = 1.6075;
    final ap = math.pow(a, p);
    final bp = math.pow(b, p);
    final cp = math.pow(c, p);

    final term = (ap * bp + ap * cp + bp * cp) / 3.0;
    final approxArea = 4 * math.pi * math.pow(term, 1.0 / p);

    return CalculationResult(
      surfaceAreaInSqMeters: approxArea.toDouble(),
      formula: 'A ≈ 4π ((a^p b^p + a^p c^p + b^p c^p) / 3)^(1/p)',
      inputsFormatted: formattedInputs,
      isApproximate: true,
      note: 'Knud Thomsen approximation formula (p = 1.6075) with maximum relative error < 1.061%.',
    );
  }
}
