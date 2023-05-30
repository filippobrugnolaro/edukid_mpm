import 'package:dartz/dartz.dart';
import '../errors/Failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
