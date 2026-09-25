import 'unit.dart';

enum ShapeType {
  sphere,
  cone,
  cube,
  cylinder,
  cuboid,
  capsule,
  sphericalCap,
  frustum,
  ellipsoid,
}

class InputFieldSpec {
  final String key;
  final String label;
  final String hint;
  final LengthUnit defaultUnit;

  const InputFieldSpec({
    required this.key,
    required this.label,
    required this.hint,
    this.defaultUnit = LengthUnit.meter,
  });
}

class ShapeConfig {
  final ShapeType type;
  final String name;
  final String subtitle;
  final String description;
  final String formulaPreview;
  final String fullFormula;
  final List<InputFieldSpec> inputs;
  final bool isApproximate;

  const ShapeConfig({
    required this.type,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.formulaPreview,
    required this.fullFormula,
    required this.inputs,
    this.isApproximate = false,
  });

  static const List<ShapeConfig> allShapes = [
    ShapeConfig(
      type: ShapeType.sphere,
      name: 'Ball / Sphere',
      subtitle: 'Calculate surface area of a sphere',
      description: 'The surface area of a sphere is proportional to the square of its radius.',
      formulaPreview: 'A = 4πr²',
      fullFormula: 'Surface Area = 4 × π × r²',
      inputs: [
        InputFieldSpec(key: 'radius', label: 'Radius (r)', hint: 'Enter radius'),
      ],
    ),
    ShapeConfig(
      type: ShapeType.cone,
      name: 'Cone',
      subtitle: 'Calculate total surface area of a cone',
      description: 'Calculates the slant height l = √(r² + h²) and total surface area including base.',
      formulaPreview: 'A = πr(r + l)',
      fullFormula: 'Surface Area = π × r × (r + l) where l = √(r² + h²)',
      inputs: [
        InputFieldSpec(key: 'radius', label: 'Base Radius (r)', hint: 'Enter base radius'),
        InputFieldSpec(key: 'height', label: 'Height (h)', hint: 'Enter vertical height'),
      ],
    ),
    ShapeConfig(
      type: ShapeType.cube,
      name: 'Cube',
      subtitle: 'Calculate surface area of a cube',
      description: 'A cube has six equal square faces, each of area a².',
      formulaPreview: 'A = 6a²',
      fullFormula: 'Surface Area = 6 × a²',
      inputs: [
        InputFieldSpec(key: 'edge', label: 'Edge Length (a)', hint: 'Enter edge length'),
      ],
    ),
    ShapeConfig(
      type: ShapeType.cylinder,
      name: 'Cylindrical Tank',
      subtitle: 'Total closed-cylinder surface area',
      description: 'Calculates the total surface area of a closed cylinder (top, bottom, and lateral wall).',
      formulaPreview: 'A = 2πr(r + h)',
      fullFormula: 'Surface Area = 2 × π × r × (r + h)',
      inputs: [
        InputFieldSpec(key: 'radius', label: 'Radius (r)', hint: 'Enter cylinder radius'),
        InputFieldSpec(key: 'height', label: 'Height (h)', hint: 'Enter cylinder height'),
      ],
    ),
    ShapeConfig(
      type: ShapeType.cuboid,
      name: 'Rectangular Tank / Cuboid',
      subtitle: 'Calculate surface area of a rectangular prism',
      description: 'Calculates the total area of all 6 rectangular faces of a box/tank.',
      formulaPreview: 'A = 2(lw + lh + wh)',
      fullFormula: 'Surface Area = 2 × (l×w + l×h + w×h)',
      inputs: [
        InputFieldSpec(key: 'length', label: 'Length (l)', hint: 'Enter length'),
        InputFieldSpec(key: 'width', label: 'Width (w)', hint: 'Enter width'),
        InputFieldSpec(key: 'height', label: 'Height (h)', hint: 'Enter height'),
      ],
    ),
    ShapeConfig(
      type: ShapeType.capsule,
      name: 'Capsule',
      subtitle: 'Surface area of a capsule (stadium of revolution)',
      description: 'A capsule consists of a cylindrical central body of height h with hemispherical caps of radius r at both ends.',
      formulaPreview: 'A = 4πr² + 2πrh',
      fullFormula: 'Surface Area = 4 × π × r² + 2 × π × r × h',
      inputs: [
        InputFieldSpec(key: 'radius', label: 'Radius (r)', hint: 'Enter cap/cylinder radius'),
        InputFieldSpec(key: 'height', label: 'Cylindrical Section Height (h)', hint: 'Enter middle cylinder height'),
      ],
    ),
    ShapeConfig(
      type: ShapeType.sphericalCap,
      name: 'Spherical Cap',
      subtitle: 'Curved and total surface area of a spherical cap',
      description: 'Calculates the curved surface area (2πRh) and total surface area including base (2πRh + πa²).',
      formulaPreview: 'A_curved = 2πRh',
      fullFormula: 'Curved Area = 2 × π × R × h; Total Area = 2πRh + πa²',
      inputs: [
        InputFieldSpec(key: 'sphereRadius', label: 'Sphere Radius (R)', hint: 'Enter main sphere radius'),
        InputFieldSpec(key: 'height', label: 'Cap Height (h)', hint: 'Enter cap height (h ≤ 2R)'),
      ],
    ),
    ShapeConfig(
      type: ShapeType.frustum,
      name: 'Conical Frustum',
      subtitle: 'Total surface area of a truncated cone',
      description: 'Calculates slant height l = √((R-r)² + h²) and total surface area including top and bottom circles.',
      formulaPreview: 'A = π(R+r)l + πR² + πr²',
      fullFormula: 'Surface Area = π × (R + r) × l + π × R² + π × r²',
      inputs: [
        InputFieldSpec(key: 'topRadius', label: 'Top Radius (r)', hint: 'Enter top radius'),
        InputFieldSpec(key: 'bottomRadius', label: 'Bottom Radius (R)', hint: 'Enter bottom radius'),
        InputFieldSpec(key: 'height', label: 'Height (h)', hint: 'Enter frustum height'),
      ],
    ),
    ShapeConfig(
      type: ShapeType.ellipsoid,
      name: 'Ellipsoid',
      subtitle: 'Approximate surface area using Knud Thomsen formula',
      description: 'Calculates an accurate numerical approximation for a tri-axial ellipsoid (semi-axes a, b, c) with error < 1.061%.',
      formulaPreview: 'A ≈ 4π ((a^p b^p + a^p c^p + b^p c^p)/3)^(1/p)',
      fullFormula: 'Approximate Area ≈ 4π × [ (a^p b^p + a^p c^p + b^p c^p) / 3 ]^(1/p) where p = 1.6075',
      inputs: [
        InputFieldSpec(key: 'axisA', label: 'Axis 1 / Semi-axis (a)', hint: 'Enter semi-axis a'),
        InputFieldSpec(key: 'axisB', label: 'Axis 2 / Semi-axis (b)', hint: 'Enter semi-axis b'),
        InputFieldSpec(key: 'axisC', label: 'Axis 3 / Semi-axis (c)', hint: 'Enter semi-axis c'),
      ],
      isApproximate: true,
    ),
  ];

  static ShapeConfig findByType(ShapeType type) {
    return allShapes.firstWhere((s) => s.type == type);
  }
}
