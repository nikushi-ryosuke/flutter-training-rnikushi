import 'package:flutter/foundation.dart';

typedef ComputeRunner = Future<R> Function<M, R>(
  ComputeCallback<M, R> callback,
  M message,
);
