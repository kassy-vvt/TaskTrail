import 'package:firebase_auth/firebase_auth.dart';

// utilなのにviewに依存しているのはよくない。
// UserProvider を作成すれば良い。[goals_provider.dart]を参照
User? getCurrentUser() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    throw ((e) => 'ログインしていません');
  }
  return currentUser;
}
