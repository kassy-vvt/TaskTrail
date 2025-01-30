import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StreamProvider を使用して、Firebase Authentication の authStateChanges() ストリームをリッスンします。
/// authStateChanges() ストリームは、ユーザーの認証状態が変化するたびに新しい User オブジェクトを流します。
/// userProvider は、ユーザーの認証状態 (User?) を提供します。
final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
