import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat.dart';

// Model
class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});
}

// Service
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      return UserModel(
          id: user.uid, name: user.displayName ?? '', email: user.email ?? '');
    } on FirebaseAuthException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }

  Future<UserModel> signup(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      return UserModel(
          id: user.uid, name: user.displayName ?? '', email: user.email ?? '');
    } on FirebaseAuthException catch (e) {
      throw Exception('Signup failed: ${e.message}');
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}

// ViewModel
class AuthViewModel extends StateNotifier<UserModel?> {
  AuthViewModel() : super(null);

  Future<void> login(String email, String password) async {
    try {
      state = await AuthService().login(email, password);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signup(
      String email, String password, BuildContext context) async {
    try {
      state = await AuthService().signup(email, password);
      Navigator.pushReplacementNamed(context, '/chat');
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await AuthService().logout();
    state = null;
  }
}

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, UserModel?>((ref) => AuthViewModel());

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // バインディングを初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: TaskTrail()));
}

class TaskTrail extends StatelessWidget {
  const TaskTrail({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Trail',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const RootLayout(),
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}

class RootLayout extends ConsumerWidget {
  const RootLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Trail'),
      ),
      body: Center(
        child: user == null ? const AuthPage() : const LogoutPage(),
      ),
    );
  }
}

// Auth Page (Login and Signup)
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, child) {
                return ElevatedButton(
                  onPressed: () {
                    if (_isLogin) {
                      ref.read(authViewModelProvider.notifier).login(
                            _emailController.text,
                            _passwordController.text,
                          );
                    } else {
                      ref.read(authViewModelProvider.notifier).signup(
                            _emailController.text,
                            _passwordController.text,
                            context,
                          );
                    }
                  },
                  child: Text(_isLogin ? 'Login' : 'Signup'),
                );
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                  _isLogin ? 'Create an account' : 'Already have an account?'),
            ),
          ],
        ),
      ),
    );
  }
}

// Logout Page
class LogoutPage extends ConsumerWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authViewModel.logout();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
