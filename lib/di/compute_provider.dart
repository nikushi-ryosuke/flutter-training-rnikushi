import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ComputeRunner = Future<R> Function<M, R>(
  ComputeCallback<M, R> callback,
  M message,
);

final computeProvider = Provider<ComputeRunner>((ref) => compute);
