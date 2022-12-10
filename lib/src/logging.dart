// ignore_for_file: avoid_print

import 'package:logging/logging.dart' as logging;

/// Overlord logger names.
class LogNames {
  static const cupertino = 'cupertino';
  static const cupertinoToolbar = 'cupertino.toolbar';
  static const cupertinoMenu = 'cupertino.menu';
}

/// Overlord logging.
class OverlordLogs {
  static final cupertino = logging.Logger(LogNames.cupertino);
  static final cupertinoToolbar = logging.Logger(LogNames.cupertinoToolbar);
  static final cupertinoMenu = logging.Logger(LogNames.cupertinoMenu);

  static final _activeLoggers = <logging.Logger>{};

  /// Initialize the given [loggers] using the minimum [level].
  ///
  /// To enable all the loggers, use [OverlordLogs.initAllLogs].
  static void initLoggers(logging.Level level, Set<logging.Logger> loggers) {
    logging.hierarchicalLoggingEnabled = true;

    for (final logger in loggers) {
      if (!_activeLoggers.contains(logger)) {
        print('Initializing logger: ${logger.name}');
        logger
          ..level = level
          ..onRecord.listen(_printLog);

        _activeLoggers.add(logger);
      }
    }
  }

  /// Initializes all the available loggers.
  ///
  /// To control which loggers are initialized, use [OverlordLogs.initLoggers].
  static void initAllLogs(logging.Level level) {
    initLoggers(level, {logging.Logger.root});
  }

  /// Returns `true` if the given [logger] is currently logging, or
  /// `false` otherwise.
  ///
  /// Generally, developers should call loggers, regardless of whether
  /// a given logger is active. However, sometimes you may want to log
  /// information that's costly to compute. In such a case, you can
  /// choose to compute the expensive information only if the given
  /// logger will actually log the information.
  static bool isLogActive(logging.Logger logger) {
    return _activeLoggers.contains(logger);
  }

  /// Deactivates the given [loggers].
  static void deactivateLoggers(Set<logging.Logger> loggers) {
    for (final logger in loggers) {
      if (_activeLoggers.contains(logger)) {
        print('Deactivating logger: ${logger.name}');
        logger.clearListeners();

        _activeLoggers.remove(logger);
      }
    }
  }

  /// Logs a record using a print statement.
  static void _printLog(logging.LogRecord record) {
    print(
        '(${record.time.second}.${record.time.millisecond.toString().padLeft(3, '0')}) ${record.loggerName} > ${record.level.name}: ${record.message}');
  }
}
