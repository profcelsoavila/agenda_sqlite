import 'package:flutter/material.dart';
import 'agenda.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  build(context) {
    return const MaterialApp(
      title: 'Contatos',
      home: Agenda(),
    );
  }
}
