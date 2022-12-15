import 'package:flutter_app_book_store/shared/validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Testing phone',
    () {
      const phone = '0987988620';
      final result = Validation.isPhoneValid(phone);
      expect(result, true);

      const phone1 = '0987988620000';
      final result1 = Validation.isPhoneValid(phone1);
      expect(result1, false);

      const phone2 = '098798862';
      final result2 = Validation.isPhoneValid(phone2);
      expect(result2, false);

      const password = 'hiem2001';
      final result3 = Validation.isPasswordValid(password);
      expect(result3, true);

      const password1 = 'hiem 2001';
      final result4 = Validation.isPasswordValid(password1);
      expect(result4, false);

      const password2 = 'hiem';
      final result5 = Validation.isPasswordValid(password2);
      expect(result5, false);

      const password3 = 'hiemhiem';
      final result6 = Validation.isPasswordValid(password3);
      expect(result6, false);
    },
  );
}
