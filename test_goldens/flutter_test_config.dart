import 'dart:async';

import 'package:flutter_test_goldens/flutter_test_goldens.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Adjust the theme that's applied to all golden tests in this suite.
  GoldenSceneTheme.push(GoldenSceneTheme.standardDark);

  return testMain();
}
