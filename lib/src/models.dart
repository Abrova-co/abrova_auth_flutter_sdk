/// A signed-in user of your app.
class AbrovaAuthUser {
  const AbrovaAuthUser({
    required this.id,
    this.anonymous = false,
    this.emailVerified = false,
    this.createdAt,
    this.providers = const [],
  });

  /// Stable user id. Use it as the user id in the other Abrova SDKs.
  final String id;

  /// True for a user from [AbrovaAuth.signInAnonymously] that has not linked
  /// a sign-in method yet.
  final bool anonymous;
  final bool emailVerified;
  final DateTime? createdAt;

  /// Linked sign-in methods: `apple`, `google`, `password`, `telegram`, ...
  final List<String> providers;

  factory AbrovaAuthUser.fromJson(Map<String, dynamic> json) => AbrovaAuthUser(
        id: json['id'] as String,
        anonymous: json['anonymous'] == true,
        emailVerified: json['emailVerified'] == true,
        createdAt: json['createdAt'] is String
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        providers: (json['providers'] as List?)?.whereType<String>().toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'anonymous': anonymous,
        'emailVerified': emailVerified,
        if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
        'providers': providers,
      };

  @override
  bool operator ==(Object other) =>
      other is AbrovaAuthUser &&
      other.id == id &&
      other.anonymous == anonymous &&
      other.emailVerified == emailVerified &&
      other.createdAt == createdAt &&
      _sameList(other.providers, providers);

  @override
  int get hashCode =>
      Object.hash(id, anonymous, emailVerified, createdAt, Object.hashAll(providers));

  @override
  String toString() => 'AbrovaAuthUser($id, anonymous: $anonymous)';
}

bool _sameList(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// The sign-in methods this project offers (turned on in the Console).
class AbrovaAuthMethods {
  const AbrovaAuthMethods({required this.methods, this.telegramBot});

  /// Any of `anonymous`, `apple`, `google`, `password`, `magicLink`, `telegram`.
  /// Empty when Abrova Auth is off for the project.
  final List<String> methods;

  /// The project's Telegram bot username, when Telegram sign-in is on.
  final String? telegramBot;

  bool get anonymous => methods.contains('anonymous');
  bool get apple => methods.contains('apple');
  bool get google => methods.contains('google');
  bool get password => methods.contains('password');
  bool get magicLink => methods.contains('magicLink');
  bool get telegram => methods.contains('telegram');

  factory AbrovaAuthMethods.fromJson(Map<String, dynamic> json) =>
      AbrovaAuthMethods(
        methods: (json['methods'] as List?)?.whereType<String>().toList() ??
            const [],
        telegramBot: json['telegramBot'] as String?,
      );
}

/// Result of [AbrovaAuth.signUpWithEmail].
class AbrovaSignUpResult {
  const AbrovaSignUpResult({
    required this.userId,
    required this.verificationSent,
    this.user,
  });

  final String userId;

  /// A confirmation e-mail was sent.
  final bool verificationSent;

  /// The signed-in user, or null when the project requires a confirmed e-mail
  /// before the first sign-in.
  final AbrovaAuthUser? user;

  bool get signedIn => user != null;
}

/// Result of [AbrovaAuth.requestTelegramCode].
class AbrovaTelegramCodeResult {
  const AbrovaTelegramCodeResult({
    required this.sent,
    required this.expiresIn,
    this.botUrl,
  });

  /// The code was sent to the user's Telegram.
  final bool sent;

  /// When [sent] is false: the user must open this bot link once and share
  /// their phone number; then call [AbrovaAuth.requestTelegramCode] again.
  final String? botUrl;

  /// How long the code stays valid.
  final Duration expiresIn;

  factory AbrovaTelegramCodeResult.fromJson(Map<String, dynamic> json) =>
      AbrovaTelegramCodeResult(
        sent: json['sent'] == true,
        botUrl: json['botUrl'] as String?,
        expiresIn: Duration(seconds: (json['expiresIn'] as num?)?.toInt() ?? 0),
      );
}
