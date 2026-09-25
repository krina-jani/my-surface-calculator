import 'package:flutter/material.dart';
import '../models/calculator_type.dart';
import '../models/calculation_result.dart';
import '../models/unit.dart';
import '../calculators/shape_calculators.dart';
import '../widgets/shape_painters.dart';
import '../widgets/result_card.dart';

class CalculatorDetailScreen extends StatefulWidget {
  final ShapeConfig config;

  const CalculatorDetailScreen({super.key, required this.config});

  @override
  State<CalculatorDetailScreen> createState() => _CalculatorDetailScreenState();
}

class _CalculatorDetailScreenState extends State<CalculatorDetailScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, LengthUnit> _selectedUnits = {};
  
  String? _errorMessage;
  CalculationResult? _result;

  @override
  void initState() {
    super.initState();
    for (var spec in widget.config.inputs) {
      _controllers[spec.key] = TextEditingController();
      _selectedUnits[spec.key] = spec.defaultUnit;
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onCalculate() {
    FocusScope.of(context).unfocus();

    final rawInputs = <String, String>{};
    for (var spec in widget.config.inputs) {
      rawInputs[spec.key] = _controllers[spec.key]?.text ?? '';
    }

    final validationErr = ShapeCalculator.validateInputs(widget.config.type, rawInputs);

    if (validationErr != null) {
      setState(() {
        _errorMessage = validationErr;
        _result = null;
      });
      return;
    }

    final res = ShapeCalculator.calculate(widget.config.type, rawInputs, _selectedUnits);

    setState(() {
      _errorMessage = null;
      _result = res;
    });
  }

  void _onClear() {
    FocusScope.of(context).unfocus();
    for (var c in _controllers.values) {
      c.clear();
    }
    setState(() {
      _errorMessage = null;
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.config.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Clear All',
            onPressed: _onClear,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shape Illustration
              ShapeIllustrationWidget(shapeType: widget.config.type),
              const SizedBox(height: 16),

              // Title and Description
              Text(
                widget.config.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.config.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),

              // Formula preview box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.functions_rounded, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.config.fullFormula,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Input Fields Header
              const Text(
                'Enter Dimensions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Dynamic Input Fields
              ...widget.config.inputs.map((spec) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllers[spec.key],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: spec.label,
                            hintText: spec.hint,
                          ),
                          onChanged: (_) {
                            if (_errorMessage != null) {
                              setState(() {
                                _errorMessage = null;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Unit dropdown
                      Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<LengthUnit>(
                            value: _selectedUnits[spec.key],
                            borderRadius: BorderRadius.circular(12),
                            items: LengthUnit.values.map((unit) {
                              return DropdownMenuItem<LengthUnit>(
                                value: unit,
                                child: Text(
                                  unit.symbol,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                            onChanged: (newUnit) {
                              if (newUnit != null) {
                                setState(() {
                                  _selectedUnits[spec.key] = newUnit;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Error Message if present
              if (_errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Action Buttons Row: Calculate & Clear
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _onCalculate,
                      icon: const Icon(Icons.calculate_rounded),
                      label: const Text('Calculate'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: _onClear,
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Result Section
              if (_result != null) ...[
                ResultCard(
                  result: _result!,
                  initialAreaUnit: AreaUnit.defaultFor(
                    _selectedUnits[widget.config.inputs.first.key] ?? LengthUnit.meter,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
