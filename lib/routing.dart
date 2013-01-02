// Copyright (c) 2012, Google Inc
// Author: afshar@google.com (Ali Afshar)

library routing;

import 'dart:io';
import 'dart:math' as math;
import 'package:logging/logging.dart';

part 'src/utils.dart';
part 'src/interfaces.dart';
part 'src/method.dart';
part 'src/path.dart';
part 'src/route.dart';
part 'src/static.dart';
part 'src/errors.dart';

var logFine = Logger.root.fine;