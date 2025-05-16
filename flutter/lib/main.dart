import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/events/event_list_screen.dart';
import 'utils/route_guard.dart';
import 'screens/splash_screen.dart';
import 'screens/events/create_event_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Event Discovery App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/events': (context) => const EventListScreen(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/profile':
                  return MaterialPageRoute(
                    builder: (context) => AuthGuard(
                      child: const Text('Profile Screen'),
                    ),
                  );

                case '/events/create':
                  return MaterialPageRoute(
                    builder: (context) => RoleGuard(
                      allowedRoles: ['organizer', 'admin'],
                      child: const CreateEventScreen(),
                    ),
                  );

                default:
                  return MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      body: Center(child: Text('Page not found')),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}