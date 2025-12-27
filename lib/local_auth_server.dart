import 'dart:io';
import 'package:logger/logger.dart';

class LocalAuthServer {
  final log = Logger(
    printer: PrefixPrinter(
      PrettyPrinter(),
      debug: '[liblogin_native:LocalAuthServer] D/',
      warning: '[liblogin_native:LocalAuthServer] W/',
      error: '[liblogin_native:LocalAuthServer] E/',
      info: '[liblogin_native:LocalAuthServer] I/',
      fatal: '[liblogin_native:LocalAuthServer] F/',
      trace: '[liblogin_native:LocalAuthServer] T/',
    ),
  );

  HttpServer? _server;

  Future<void> start(Function(String url) onRedirect, {int port = 8989}) async {
    if (_server != null) {
      log.w('Server is already running.');
      return;
    }

    try {
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      log.i('Local auth server started on http://localhost:$port');

      _server!.listen((HttpRequest request) async {
        log.i('Received request: ${request.uri}');
        final fullUrl = 'http://localhost:$port${request.uri.toString()}';

        // Pass the full URL to the callback
        onRedirect(fullUrl);

        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.html
          ..write('''
            <html>
              <head>
                <title>Authentication Successful</title>
              </head>
              <body>
                <h1>Authentication successful!</h1>
                <p>You can now close this window.</p>
                <script>
                  window.close();
                </script>
              </body>
            </html>
          ''');
        await request.response.close();

        // Stop the server after handling the redirect
        await stop();
      });
    } catch (e) {
      log.e('Failed to start local auth server on port $port: $e');
      _server = null;
      // Re-throw the exception so the caller can handle it
      rethrow;
    }
  }

  Future<void> stop() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      log.i('Local auth server stopped.');
    }
  }
}
