import 'package:flutter/foundation.dart';

Future<R> computeDirectly<M, R>(
  ComputeCallback<M, R> callback,
  M message,
) async => callback(message);
