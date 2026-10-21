import 'package:flutter/material.dart';

class Cat {
  final String name;
  final IconData icon;
  final Color color;
  const Cat(this.name, this.icon, this.color);
}

const cats = [
  Cat('Makan', Icons.restaurant, Color(0xFFE57373)),
  Cat('Transportasi', Icons.directions_bus, Color(0xFF64B5F6)),
  Cat('Kebutuhan Mandi', Icons.shopping_basket, Color(0xFF81C784)),
  Cat('Kesehatan', Icons.add_circle, Color(0xFF4DB6AC)),
  Cat('Pendidikan', Icons.menu_book, Color(0xFF7986CB)),
  Cat('Hiburan', Icons.sports_esports, Color(0xFFBA68C8)),
  Cat('Belanja', Icons.shopping_bag, Color(0xFFFF8A65)),
  Cat('Pulsa & Internet', Icons.wifi, Color(0xFF4FC3F7)),
  Cat('Lainnya', Icons.more_horiz, Color(0xFF9E9E9E)),
];
Cat catOf(String n) => cats.firstWhere((c) => c.name == n, orElse: () => cats.last);

