import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:surface_area_calculator/models/calculator_type.dart';
import 'package:surface_area_calculator/models/unit.dart';
import 'package:surface_area_calculator/calculators/shape_calculators.dart';
import 'package:surface_area_calculator/services/unit_converter.dart';

void main() {
  group('UnitConverter Tests', () {
    test('Length Conversions to Meters', () {
      expect(UnitConverter.lengthToMeters(100, LengthUnit.centimeter), closeTo(1.0, 1e-9));
      expect(UnitConverter.lengthToMeters(1000, LengthUnit.millimeter), closeTo(1.0, 1e-9));
      expect(UnitConverter.lengthToMeters(1, LengthUnit.kilometer), closeTo(1000.0, 1e-9));
      expect(UnitConverter.lengthToMeters(1, LengthUnit.inch), closeTo(0.0254, 1e-9));
      expect(UnitConverter.lengthToMeters(1, LengthUnit.foot), closeTo(0.3048, 1e-9));
      expect(UnitConverter.lengthToMeters(1, LengthUnit.yard), closeTo(0.9144, 1e-9));
      expect(UnitConverter.lengthToMeters(1, LengthUnit.mile), closeTo(1609.344, 1e-9));
    });

    test('Area Conversions from Square Meters', () {
      expect(UnitConverter.squareMetersToArea(1.0, AreaUnit.squareCentimeter), closeTo(10000.0, 1e-6));
      expect(UnitConverter.squareMetersToArea(1.0, AreaUnit.squareMillimeter), closeTo(1000000.0, 1e-6));
      expect(UnitConverter.squareMetersToArea(1000000.0, AreaUnit.squareKilometer), closeTo(1.0, 1e-6));
    });
  });

  group('Validation Tests', () {
    test('Rejects empty input', () {
      final err = ShapeCalculator.validateInputs(ShapeType.sphere, {'radius': ''});
      expect(err, isNotNull);
      expect(err, contains('Please enter a value'));
    });

    test('Rejects non-numeric input', () {
      final err = ShapeCalculator.validateInputs(ShapeType.sphere, {'radius': 'abc'});
      expect(err, isNotNull);
      expect(err, contains('valid number'));
    });

    test('Rejects zero input', () {
      final err = ShapeCalculator.validateInputs(ShapeType.sphere, {'radius': '0'});
      expect(err, isNotNull);
      expect(err, contains('greater than zero'));
    });

    test('Rejects negative input', () {
      final err = ShapeCalculator.validateInputs(ShapeType.sphere, {'radius': '-5'});
      expect(err, isNotNull);
      expect(err, contains('greater than zero'));
    });

    test('Spherical Cap height validation', () {
      final err = ShapeCalculator.validateInputs(ShapeType.sphericalCap, {
        'sphereRadius': '5',
        'height': '12',
      });
      expect(err, isNotNull);
      expect(err, contains('cannot exceed sphere diameter'));
    });
  });

  group('Calculator Engine Formula Tests', () {
    test('A. Ball / Sphere Formula (r = 1m -> 4π ≈ 12.566370614)', () {
      final result = ShapeCalculator.calculate(
        ShapeType.sphere,
        {'radius': '1'},
        {'radius': LengthUnit.meter},
      );
      final expected = 4 * math.pi;
      expect(result.surfaceAreaInSqMeters, closeTo(expected, 1e-7));
    });

    test('B. Cone Formula (r = 3, h = 4 -> l = 5, Area = 24π)', () {
      final result = ShapeCalculator.calculate(
        ShapeType.cone,
        {'radius': '3', 'height': '4'},
        {'radius': LengthUnit.meter, 'height': LengthUnit.meter},
      );
      final expected = 24 * math.pi; // π * 3 * (3 + 5) = 24π
      expect(result.surfaceAreaInSqMeters, closeTo(expected, 1e-7));
    });

    test('C. Cube Formula (a = 1m -> 6m²)', () {
      final result = ShapeCalculator.calculate(
        ShapeType.cube,
        {'edge': '1'},
        {'edge': LengthUnit.meter},
      );
      expect(result.surfaceAreaInSqMeters, closeTo(6.0, 1e-9));
    });

    test('D. Cylindrical Tank Formula (r = 1, h = 1 -> 4π ≈ 12.566370614)', () {
      final result = ShapeCalculator.calculate(
        ShapeType.cylinder,
        {'radius': '1', 'height': '1'},
        {'radius': LengthUnit.meter, 'height': LengthUnit.meter},
      );
      final expected = 4 * math.pi; // 2π*1*(1+1) = 4π
      expect(result.surfaceAreaInSqMeters, closeTo(expected, 1e-7));
    });

    test('E. Rectangular Tank / Cuboid (l=2, w=3, h=4 -> 2(6+8+12) = 52m²)', () {
      final result = ShapeCalculator.calculate(
        ShapeType.cuboid,
        {'length': '2', 'width': '3', 'height': '4'},
        {
          'length': LengthUnit.meter,
          'width': LengthUnit.meter,
          'height': LengthUnit.meter,
        },
      );
      expect(result.surfaceAreaInSqMeters, closeTo(52.0, 1e-9));
    });

    test('F. Capsule (r = 1, h = 2 -> 4π(1)² + 2π(1)(2) = 8π)', () {
      final result = ShapeCalculator.calculate(
        ShapeType.capsule,
        {'radius': '1', 'height': '2'},
        {'radius': LengthUnit.meter, 'height': LengthUnit.meter},
      );
      final expected = 8 * math.pi;
      expect(result.surfaceAreaInSqMeters, closeTo(expected, 1e-7));
    });

    test('G. Spherical Cap (R = 5, h = 2 -> a = √(2*5*2 - 4) = 4, Total Area = 2π*5*2 + π*4² = 36π)', () {
      final result = ShapeCalculator.calculate(
        ShapeType.sphericalCap,
        {'sphereRadius': '5', 'height': '2'},
        {'sphereRadius': LengthUnit.meter, 'height': LengthUnit.meter},
      );
      final expected = 36 * math.pi;
      expect(result.surfaceAreaInSqMeters, closeTo(expected, 1e-7));
    });

    test('H. Conical Frustum (r=1, R=4, h=4 -> l=5, Area = π(5)(5) + π(16) + π(1) = 42π)', () {
      final result = ShapeCalculator.calculate(
        ShapeType.frustum,
        {'topRadius': '1', 'bottomRadius': '4', 'height': '4'},
        {
          'topRadius': LengthUnit.meter,
          'bottomRadius': LengthUnit.meter,
          'height': LengthUnit.meter,
        },
      );
      final expected = 42 * math.pi;
      expect(result.surfaceAreaInSqMeters, closeTo(expected, 1e-7));
    });

    test('I. Ellipsoid Approximation (a=1, b=1, c=1 -> Sphere 4π ≈ 12.566370614)', () {
      final result = ShapeCalculator.calculate(
        ShapeType.ellipsoid,
        {'axisA': '1', 'axisB': '1', 'axisC': '1'},
        {
          'axisA': LengthUnit.meter,
          'axisB': LengthUnit.meter,
          'axisC': LengthUnit.meter,
        },
      );
      final expected = 4 * math.pi;
      expect(result.surfaceAreaInSqMeters, closeTo(expected, 1e-4));
      expect(result.isApproximate, isTrue);
    });

    test('Unit Conversion In Calculator (r = 100 cm = 1 m -> Area = 4π m²)', () {
      final result = ShapeCalculator.calculate(
        ShapeType.sphere,
        {'radius': '100'},
        {'radius': LengthUnit.centimeter},
      );
      final expected = 4 * math.pi;
      expect(result.surfaceAreaInSqMeters, closeTo(expected, 1e-7));
    });
  });
}
