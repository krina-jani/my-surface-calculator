enum LengthUnit {
  millimeter('Millimeter', 'mm', 0.001),
  centimeter('Centimeter', 'cm', 0.01),
  meter('Meter', 'm', 1.0),
  kilometer('Kilometer', 'km', 1000.0),
  inch('Inch', 'in', 0.0254),
  foot('Foot', 'ft', 0.3048),
  yard('Yard', 'yd', 0.9144),
  mile('Mile', 'mi', 1609.344);

  final String name;
  final String symbol;
  final double metersFactor;

  const LengthUnit(this.name, this.symbol, this.metersFactor);
}

enum AreaUnit {
  squareMillimeter('Square Millimeter', 'mm²', 0.000001),
  squareCentimeter('Square Centimeter', 'cm²', 0.0001),
  squareMeter('Square Meter', 'm²', 1.0),
  squareKilometer('Square Kilometer', 'km²', 1000000.0),
  squareInch('Square Inch', 'in²', 0.00064516),
  squareFoot('Square Foot', 'ft²', 0.09290304),
  squareYard('Square Yard', 'yd²', 0.83612736),
  squareMile('Square Mile', 'mi²', 2589988.110336);

  final String name;
  final String symbol;
  final double squareMetersFactor; // Value in m² for 1 unit²

  const AreaUnit(this.name, this.symbol, this.squareMetersFactor);

  static AreaUnit defaultFor(LengthUnit lengthUnit) {
    switch (lengthUnit) {
      case LengthUnit.millimeter:
        return AreaUnit.squareMillimeter;
      case LengthUnit.centimeter:
        return AreaUnit.squareCentimeter;
      case LengthUnit.meter:
        return AreaUnit.squareMeter;
      case LengthUnit.kilometer:
        return AreaUnit.squareKilometer;
      case LengthUnit.inch:
        return AreaUnit.squareInch;
      case LengthUnit.foot:
        return AreaUnit.squareFoot;
      case LengthUnit.yard:
        return AreaUnit.squareYard;
      case LengthUnit.mile:
        return AreaUnit.squareMile;
    }
  }
}
