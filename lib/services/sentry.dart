import 'package:sentry/sentry.dart';

final String _dsn =
    'https://9b360a872f1b49668b40f8fc7c8dae6d@o204245.ingest.sentry.io/5266507';

class Sentry {
  final SentryClient _sentry;
  Sentry({
    SentryClient sentry,
  }) : _sentry = sentry ??
            SentryClient(
              dsn: _dsn,
            );
  Future<void> report(dynamic error, dynamic stackTrace) async {
    _sentry.captureException(exception: error, stackTrace: stackTrace);
  }
}
