/// The SDK version. Keep it equal to `version:` in pubspec.yaml — a test checks it.
const String abrovaAuthSdkVersion = '0.1.1';

/// Sent as `X-Abrova-SDK` with every request, so Abrova can show which SDK versions are in use.
const String abrovaAuthSdkHeader = 'auth-flutter/$abrovaAuthSdkVersion';
