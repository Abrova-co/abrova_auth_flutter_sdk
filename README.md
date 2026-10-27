<p align="center">
  <a href="https://abrova.ir">
    <img src="https://abrova.ir/icon.svg" alt="Abrova" width="120" />
  </a>
</p>

<h3 align="center">Abrova Auth Flutter SDK</h3>

<p align="center">
  Sign-in for your app's users, with a user token every Abrova SDK accepts.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart&logoColor=white" alt="Dart 3.0+" />
  <img src="https://img.shields.io/badge/Flutter-3.13+-02569B?logo=flutter&logoColor=white" alt="Flutter 3.13+" />
  <img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Web%20%7C%20Desktop-lightgrey" alt="Platforms" />
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License" />
</p>

---

## Installation

The package is published on [Abrova Center](https://center.abrova.ir):

```yaml
dependencies:
  abrova_auth:
    hosted: https://center.abrova.ir/api/packages/abrova/pub
    version: ^0.1.1
```

Turn on Abrova Auth and the sign-in methods you want in the Abrova Console.

## Quick start

```dart
import 'package:abrova_auth/abrova_auth.dart';

await AbrovaAuth.initialize('ab_live_YOUR_PUBLIC_KEY'); // public key from the Console
final auth = AbrovaAuth.instance;

auth.authStateChanges.listen((user) {
  // null when signed out
});

final user = await auth.signInAnonymously();
```

`initialize` restores the saved session without a network call, so `auth.currentUser` is ready at app start.

## With the other Abrova SDKs

Pass the token provider; the SDK renews the token before it expires and every caller shares one renewal.

```dart
await AbrovaSync.init(AbrovaSyncConfig(
  apiKey: 'ab_live_YOUR_PUBLIC_KEY',
  tokenProvider: AbrovaAuth.instance.tokenProvider,
));
```

Abrova Chat takes `AbrovaAuth.instance.chatTokenProvider`. Use `currentUser.id` as the user id. Call the other
SDK's refresh method (for example `AbrovaSync.refreshUserToken()`) after a sign-in or sign-out.

## Sign-in methods

```dart
await auth.signUpWithEmail(email: email, password: password, redirectUrl: 'https://myapp.com/verify');
await auth.signInWithEmail(email: email, password: password);
await auth.sendPasswordReset(email, redirectUrl: 'https://myapp.com/reset');
await auth.resetPassword(tokenFromLink, newPassword);
await auth.sendMagicLink(email, redirectUrl: 'https://myapp.com/magic');
await auth.signInWithMagicLink(tokenFromLink);
final r = await auth.requestTelegramCode('+37491234567'); // r.sent, or open r.botUrl first
await auth.verifyTelegramCode('+37491234567', '123456');
final methods = await auth.getMethods(); // only show the buttons the project offers
```

Redirect URLs must be in the project's allowed list. The link opens with `?token=...`.

### Apple and Google

Use the native plugins you already know and give their ID token to Abrova. Send the provider the hashed nonce and
Abrova the raw one. The nonce is required for both Apple and Google (16-256 characters; `AbrovaAuthNonce.generate()`
makes one):

```dart
final raw = AbrovaAuthNonce.generate();

// sign_in_with_apple
final apple = await SignInWithApple.getAppleIDCredential(
  scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
  nonce: AbrovaAuthNonce.sha256Hex(raw),
);
await auth.signInWithApple(
  idToken: apple.identityToken!,
  rawNonce: raw,
  authorizationCode: apple.authorizationCode, // lets account deletion revoke the Apple sign-in
  name: [apple.givenName, apple.familyName].whereType<String>().join(' '),
);

// google_sign_in 7
await GoogleSignIn.instance.initialize(serverClientId: 'xxx.apps.googleusercontent.com', nonce: AbrovaAuthNonce.sha256Hex(raw));
final account = await GoogleSignIn.instance.authenticate();
await auth.signInWithGoogle(idToken: account.authentication.idToken!, rawNonce: raw);
```

Add your bundle IDs and Google client IDs in the Console. Each nonce works once.

### Upgrading an anonymous user

```dart
try {
  await auth.linkGoogle(idToken: idToken, rawNonce: raw); // same user id, data stays
} on AbrovaProviderAlreadyLinkedException {
  // This Google account already has a user: offer to sign in with it instead.
}
```

`linkApple` and `linkPassword` work the same way.

## Account

```dart
await auth.getMe();             // fresh profile
await auth.signOut();           // this device; never fails
await auth.signOutEverywhere(); // all devices
await auth.deleteAccount();     // required by the App Store for apps with sign-in
```

## Errors

Every call throws `AbrovaAuthException` with a `code` (see `AbrovaAuthErrorCode`), a developer `message` and, for
`RATE_LIMITED`, a `retryAfter`. `NETWORK_ERROR` never signs the user out. When the session ends (revoked, expired,
account disabled), the SDK signs out and `authStateChanges` emits `null`.

## Example app

[`example/`](example) is a small app with anonymous sign-in, e-mail sign-up and sign-in, sign-out and account
deletion. Paste your public key (`ab_live_...`) into its API key field:

```bash
cd example
flutter run
```

## Documentation

- [Abrova Auth Docs](https://abrova.ir/cloud/abrova-auth/docs)
- [Flutter SDK guide](https://abrova.ir/cloud/abrova-auth/docs/sdks-flutter)

## Support

- **Documentation**: [Abrova Auth Docs](https://abrova.ir/cloud/abrova-auth/docs)
- **Issues**: [GitHub Issues](https://github.com/Abrova-co/abrova_auth_flutter_sdk/issues)
- **Email**: support@abrova.ir

## License

MIT License — see [LICENSE](LICENSE) for details.
