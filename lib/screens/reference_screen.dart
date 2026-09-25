import 'package:flutter/material.dart';
import '../models/calculator_type.dart';

class ReferenceScreen extends StatelessWidget {
  const ReferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formula Reference'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surface Area Formula Reference',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Comprehensive mathematical formulas, variables, and geometric assumptions for 3D shapes.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                '3D Shape Formulas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Responsive Cards List for Formulas
              ...ShapeConfig.allShapes.map((shape) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              shape.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (shape.isApproximate)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Numerical Approx.',
                                  style: TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SelectableText(
                            shape.fullFormula,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace',
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Variables & Description:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          shape.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Variable Definitions Section
              const Text(
                'Variable Symbol Legend',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildLegendRow('r, R', 'Radius / Sphere Radius / Base Radius'),
                      _buildLegendRow('h', 'Vertical Height / Cylindrical Height'),
                      _buildLegendRow('l', 'Slant Height (√(r² + h²))'),
                      _buildLegendRow('a', 'Edge Length / Base Radius / Semi-axis 1'),
                      _buildLegendRow('b, c', 'Semi-axes for tri-axial ellipsoid'),
                      _buildLegendRow('w', 'Width of rectangular cuboid'),
                      _buildLegendRow('π', 'Pi constant (≈ 3.141592653589793)'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Unit Conversions Summary
              const Text(
                'Length & Area Unit Factors',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildLegendRow('1 meter (m)', '100 cm = 1000 mm = 39.37 in = 3.28084 ft'),
                      _buildLegendRow('1 inch (in)', '0.0254 m = 2.54 cm'),
                      _buildLegendRow('1 foot (ft)', '0.3048 m = 12 inches'),
                      _buildLegendRow('1 yard (yd)', '0.9144 m = 3 feet'),
                      _buildLegendRow('1 mile (mi)', '1609.344 m = 1.609344 km'),
                      _buildLegendRow('1 m²', '10,000 cm² = 1,000,000 mm²'),
                      _buildLegendRow('1 m²', '10.7639 sq ft = 1550.00 sq in'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendRow(String symbol, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            child: Text(
              symbol,
              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
            ),
          ),
          Expanded(
            child: Text(desc, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
