import 'package:arise/src/utils/feature_name.dart';
import 'package:test/test.dart';

void main() {
  group('FeatureName.normalize', () {
    test('converts input to lowercase', () {
      expect(FeatureName.normalize('Auth'), 'auth');
    });

    test('converts hyphens to underscores', () {
      expect(FeatureName.normalize('user-profile'), 'user_profile');
    });

    test('trims whitespace', () {
      expect(FeatureName.normalize('  auth  '), 'auth');
    });
  });

  group('FeatureName.isValid', () {
    test('accepts valid names', () {
      expect(FeatureName.isValid('auth'), isTrue);
      expect(FeatureName.isValid('user_profile'), isTrue);
      expect(FeatureName.isValid('profile2'), isTrue);
    });

    test('rejects unsafe names', () {
      expect(FeatureName.isValid('../auth'), isFalse);
      expect(FeatureName.isValid('auth/foo'), isFalse);
      expect(FeatureName.isValid('auth feature'), isFalse);
      expect(FeatureName.isValid('@auth'), isFalse);
      expect(FeatureName.isValid('2fa'), isFalse);
    });
  });
}
