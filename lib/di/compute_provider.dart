import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training/data/api/compute_runner.dart';

final computeProvider = Provider<ComputeRunner>((ref) => compute);
