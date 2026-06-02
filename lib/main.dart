import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'database_initializer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDatabase();

  runApp(const ProviderScope(child: CopaApp()));
}
