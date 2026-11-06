## 0.3.0

- `languageCode`, `setLanguageCode()` and `useDeviceLanguage()`, like Firebase: the language of the e-mails Abrova
  sends this user (confirm e-mail, password reset, magic link), for example
  `await AbrovaAuth.instance.setLanguageCode('fa')`. Unset, the project's template language from the Console applies.

## 0.2.0

- `getTokenResult({forceRefresh})`: the access token with its decoded fields, like Firebase's `getIdTokenResult()`.
  `claims` holds the custom claims your server set with `setCustomUserClaims` (for example `plan`, `role`), plus `sub`,
  `iat`, `exp`, `auth_time` and `amr`; also `expirationTime`, `issuedAtTime`, `authTime` and `signInProvider`. For
  showing things in the app; access is still decided on the server. Pass `forceRefresh: true` right after your server
  changed the claims.

## 0.1.1

- Sends `X-Abrova-SDK: auth-flutter/0.1.1` with every request so Abrova can show which SDK versions are in use. No behaviour change.

## 0.1.0

- Initial release.
- Sign-in methods: anonymous, Apple, Google, e-mail + password, magic link and Telegram code.
- Upgrade an anonymous user with `linkApple`, `linkGoogle` or `linkPassword`; the user keeps its id.
- Session kept in secure storage; the access token is renewed before it expires, with one request for all callers.
- `tokenProvider` and `chatTokenProvider` for the other Abrova SDKs.
- `AbrovaAuthNonce` helper for Apple and Google sign-in; `rawNonce` is required for Apple and Google.
- Account deletion, sign out and sign out everywhere.
