import 'package:flutter/material.dart';
import 'package:salas_hands_on_semi_finals/todo_List.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Hands On Semi Final [Salas]',
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
    home: const HomePage(),
    )
  );
}