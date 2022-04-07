import 'package:flutter/material.dart';
import 'package:movies_app/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'Movies App',
			initialRoute: 'home',
			routes: {
				'home': (_) => const HomeScreen(),
				'details': ( _ ) => const DetailsScreen(),
			},
			theme: ThemeData.dark().copyWith(
				appBarTheme: const AppBarTheme(
					//color: Colors.indigo
				)
			),
		);
	}
}