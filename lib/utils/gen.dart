import 'dart:math';

const Encoding =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-";

String genID(int n) {
  String id = '';
  final rng = Random();

  for (int i = 0; i < n; i++) {
    id += Encoding[rng.nextInt(64)];
  }

  return id;
}
