// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transacciones_app/core/providers/transacciones_provider.dart';
import 'presentation/screens/listado_transacciones_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransaccionesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transacciones',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,  
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: ListadoTransaccionesScreen(),
    );
  }
}
