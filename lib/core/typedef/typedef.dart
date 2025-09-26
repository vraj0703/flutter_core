import 'package:dart_either/dart_either.dart';

typedef OnUploadProgressCallback = void Function(int, int);

typedef FutureString<Input> = Future<Either<Exception, String>> Function(
    Input? input);
