import 'package:dart_either/dart_either.dart';

/// Abstract class for a Use Case (Interactor in terms of Clean Architecture).
/// This abstraction represents an execution unit for different use cases (this means than any use
/// case in the application should implement this contract).
/// For any given use case, we must write a strict contract of what the expected
/// arguments/return values are so we don't run into any confusion
/// [Input] and [Output] represents generic classes
/// [Input] represents expected arguments for the use case for the execution.
/// [UseCase] return [Either] [Exception] for failure or [Output],
/// which represents success return value.
abstract class UseCase<Input, Output> {
  Future<Either<Exception, Output>> invoke(Input params);
}

abstract class UseCaseYield<Input, Output> {
  Stream<Either<Exception, Output>> invoke(Input params);
}

abstract class UseCaseSync<Input, Output> {
  Output invoke(Input params);
}
