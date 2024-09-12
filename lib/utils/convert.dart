import 'dart:ui';

Color convertHex(String hex) {
  hex = hex.replaceFirst('#', '');
  final buffer = StringBuffer();
  buffer.write('ff');
  buffer.write(hex);

  return Color(int.parse(buffer.toString(), radix: 16));
}
