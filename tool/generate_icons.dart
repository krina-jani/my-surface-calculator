import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

class PngEncoder {
  static List<int> createPng(int width, int height, Uint8List rgbaBytes) {
    final buffer = BytesBuilder();
    // PNG Signature
    buffer.add([137, 80, 78, 71, 13, 10, 26, 10]);

    // IHDR Chunk
    final ihdr = BytesBuilder();
    ihdr.add(_uint32(width));
    ihdr.add(_uint32(height));
    ihdr.add([8, 6, 0, 0, 0]); // 8-bit RGBA
    _addChunk(buffer, 'IHDR', ihdr.toBytes());

    // IDAT Chunk (Raw scanlines with filter byte 0)
    final rawScanlines = BytesBuilder();
    final stride = width * 4;
    for (int y = 0; y < height; y++) {
      rawScanlines.addByte(0); // None filter
      final lineStart = y * stride;
      rawScanlines.add(rgbaBytes.sublist(lineStart, lineStart + stride));
    }

    final compressed = zlib.encode(rawScanlines.toBytes());
    _addChunk(buffer, 'IDAT', Uint8List.fromList(compressed));

    // IEND Chunk
    _addChunk(buffer, 'IEND', Uint8List(0));

    return buffer.toBytes();
  }

  static void _addChunk(BytesBuilder buffer, String type, Uint8List data) {
    final typeBytes = type.codeUnits;
    buffer.add(_uint32(data.length));
    buffer.add(typeBytes);
    buffer.add(data);
    
    // Calculate CRC32
    final crcInput = Uint8List(typeBytes.length + data.length);
    crcInput.setAll(0, typeBytes);
    crcInput.setAll(typeBytes.length, data);
    buffer.add(_uint32(_crc32(crcInput)));
  }

  static Uint8List _uint32(int val) {
    return Uint8List(4)..buffer.asByteData().setUint32(0, val, Endian.big);
  }

  static int _crc32(Uint8List bytes) {
    int crc = 0xFFFFFFFF;
    for (int b in bytes) {
      crc ^= b;
      for (int i = 0; i < 8; i++) {
        if ((crc & 1) != 0) {
          crc = (crc >> 1) ^ 0xEDB88320;
        } else {
          crc >>= 1;
        }
      }
    }
    return crc ^ 0xFFFFFFFF;
  }
}

void renderIcon(int size, String filePath, {bool isForegroundOnly = false}) {
  final rgba = Uint8List(size * size * 4);

  // Colors
  // Deep indigo background: #0F172A
  // Circle badge: #1E293B
  // Primary gradient: Cyan #06B6D4 to Indigo #6366F1
  // Accent gradient: Amber #F59E0B

  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final index = (y * size + x) * 4;
      
      final nx = (x / size) * 2 - 1; // -1 to 1
      final ny = (y / size) * 2 - 1; // -1 to 1
      final dist = math.sqrt(nx * nx + ny * ny);

      if (isForegroundOnly) {
        // Transparent background for adaptive foreground
        rgba[index] = 0;
        rgba[index + 1] = 0;
        rgba[index + 2] = 0;
        rgba[index + 3] = 0;
      } else {
        // Background gradient
        double bgGradient = (ny + 1) / 2;
        int r = (15 + bgGradient * 10).toInt();
        int g = (23 + bgGradient * 15).toInt();
        int b = (42 + bgGradient * 25).toInt();
        rgba[index] = r;
        rgba[index + 1] = g;
        rgba[index + 2] = b;
        rgba[index + 3] = 255;
      }

      // Draw Icon Graphics
      // 1. Outer glowing shape ring / rounded container (if not foreground only or centered)
      double ringRadius = 0.72;
      double ringThickness = 0.04;
      if (dist >= (ringRadius - ringThickness) && dist <= ringRadius) {
        double alpha = (1 - (dist - ringRadius).abs() / ringThickness);
        // Cyan-Indigo gradient
        double angle = math.atan2(ny, nx);
        double t = (angle + math.pi) / (2 * math.pi);
        int r = (6 + t * 93).toInt();
        int g = (182 - t * 80).toInt();
        int b = (212 + t * 29).toInt();
        _blendPixel(rgba, index, r, g, b, (alpha * 230).toInt());
      }

      // 2. 3D Geometric Isometric Sphere + Cube wireframe in center
      double scale = 0.42;
      
      // Draw Sphere outline and longitude/latitude curves
      double sphereR = scale * 0.7;
      if (dist <= sphereR) {
        // Shading inside sphere
        double z = math.sqrt(math.max(0, sphereR * sphereR - dist * dist));
        // Light source from (-0.5, -0.7, 0.8)
        double lx = -0.5, ly = -0.7, lz = 0.8;
        double lLen = math.sqrt(lx*lx + ly*ly + lz*lz);
        double dot = (nx * lx + ny * ly + (z/sphereR) * lz) / (sphereR * lLen);
        dot = math.max(0.1, dot);
        
        int r = (30 + dot * 180).toInt();
        int g = (100 + dot * 120).toInt();
        int b = (220 + dot * 35).toInt();
        _blendPixel(rgba, index, r, g, b, 240);
      }

      // Sphere rim light
      if ((dist - sphereR).abs() < 0.025) {
        double a = 1.0 - (dist - sphereR).abs() / 0.025;
        _blendPixel(rgba, index, 56, 189, 248, (a * 255).toInt());
      }

      // Latitude lines (curves)
      for (double lat = -0.4; lat <= 0.4; lat += 0.4) {
        double latY = lat * sphereR;
        double rx = math.sqrt(math.max(0, sphereR * sphereR - latY * latY));
        double ry = rx * 0.35; // perspective flattening
        double ellipseVal = (nx * nx) / (rx * rx) + ((ny - latY) * (ny - latY)) / (ry * ry);
        if ((ellipseVal - 1.0).abs() < 0.08 && dist <= sphereR) {
          _blendPixel(rgba, index, 255, 255, 255, 180);
        }
      }

      // Longitude line (vertical ellipse)
      double rx = sphereR * 0.4;
      double ry = sphereR;
      double lonVal = (nx * nx) / (rx * rx) + (ny * ny) / (ry * ry);
      if ((lonVal - 1.0).abs() < 0.08 && dist <= sphereR) {
        _blendPixel(rgba, index, 255, 255, 255, 180);
      }

      // Dimension Arrow line from top to bottom
      if ((nx - (-0.5)).abs() < 0.015 && ny >= -0.5 && ny <= 0.5) {
        _blendPixel(rgba, index, 245, 158, 11, 230); // Amber arrow
      }
    }
  }

  final pngBytes = PngEncoder.createPng(size, size, rgba);
  File(filePath)..createSync(recursive: true)..writeAsBytesSync(pngBytes);
}

void _blendPixel(Uint8List rgba, int index, int r, int g, int b, int a) {
  double srcA = a / 255.0;
  double dstA = rgba[index + 3] / 255.0;
  double outA = srcA + dstA * (1.0 - srcA);
  if (outA > 0) {
    rgba[index] = ((r * srcA + rgba[index] * dstA * (1 - srcA)) / outA).toInt();
    rgba[index + 1] = ((g * srcA + rgba[index + 1] * dstA * (1 - srcA)) / outA).toInt();
    rgba[index + 2] = ((b * srcA + rgba[index + 2] * dstA * (1 - srcA)) / outA).toInt();
    rgba[index + 3] = (outA * 255).toInt();
  }
}

void main() {
  final resDir = 'android/app/src/main/res';
  
  // Standard Launcher Icons
  renderIcon(48, '$resDir/mipmap-mdpi/ic_launcher.png');
  renderIcon(72, '$resDir/mipmap-hdpi/ic_launcher.png');
  renderIcon(96, '$resDir/mipmap-xhdpi/ic_launcher.png');
  renderIcon(144, '$resDir/mipmap-xxhdpi/ic_launcher.png');
  renderIcon(192, '$resDir/mipmap-xxxhdpi/ic_launcher.png');

  // Foreground adaptive icons
  renderIcon(108, '$resDir/mipmap-mdpi/ic_launcher_foreground.png', isForegroundOnly: true);
  renderIcon(162, '$resDir/mipmap-hdpi/ic_launcher_foreground.png', isForegroundOnly: true);
  renderIcon(216, '$resDir/mipmap-xhdpi/ic_launcher_foreground.png', isForegroundOnly: true);
  renderIcon(324, '$resDir/mipmap-xxhdpi/ic_launcher_foreground.png', isForegroundOnly: true);
  renderIcon(432, '$resDir/mipmap-xxxhdpi/ic_launcher_foreground.png', isForegroundOnly: true);

  // Flutter Assets App Logo
  renderIcon(512, 'assets/icon/app_logo.png');

  // Web Favicon and PWA icons
  renderIcon(48, 'web/favicon.png');
  renderIcon(192, 'web/icons/Icon-192.png');
  renderIcon(512, 'web/icons/Icon-512.png');
  renderIcon(192, 'web/icons/Icon-maskable-192.png');
  renderIcon(512, 'web/icons/Icon-maskable-512.png');
}
