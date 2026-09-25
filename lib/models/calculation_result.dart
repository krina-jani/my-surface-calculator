import 'unit.dart';

class CalculationResult {
  final double surfaceAreaInSqMeters;
  final String formula;
  final Map<String, String> inputsFormatted;
  final Map<String, String> extraDetails;
  final bool isApproximate;
  final String? note;

  const CalculationResult({
    required this.surfaceAreaInSqMeters,
    required this.formula,
    required this.inputsFormatted,
    this.extraDetails = const {},
    this.isApproximate = false,
    this.note,
  });
}
