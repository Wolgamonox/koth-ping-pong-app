import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthenticationStatus { idle, disconnected, authenticated }

const String tokenKey = 'authToken';

final kothAuthServiceProvider =
StateNotifierProvider<KothAuthService, AuthenticationStatus>(
      (ref) => KothAuthService(),
);

class KothAuthService extends StateNotifier<AuthenticationStatus> {
  KothAuthService() : super(AuthenticationStatus.idle) {
    _getTokenFromSecureStorage();
  }

  String? authToken;
  final storage = const FlutterSecureStorage();

  Future<void> _getTokenFromSecureStorage() async {
    String? value = await storage.read(key: tokenKey);

    if (value == null || value.isEmpty) {
      authToken = null;
      state = AuthenticationStatus.disconnected;
    } else {
      authToken = value;
      state = AuthenticationStatus.authenticated;
    }
  }

  /// Setter for a new AuthToken
  void setAuthToken(String newAuthToken) {
    if (newAuthToken.isNotEmpty) {
      authToken = newAuthToken;
      storage.write(key: tokenKey, value: newAuthToken);
      state = AuthenticationStatus.authenticated;
    }
  }

  /// Delete the token from the device
  void deleteToken() {
    authToken = null;
    storage.delete(key: tokenKey);
    state = AuthenticationStatus.disconnected;
  }
}
