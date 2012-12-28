// Copyright (c) 2012, Google Inc
// Author: afshar@google.com (Ali Afshar)

part of routing;

/**
 * A matchable component of a request, such as its path or method.
 */
abstract class RouteComponent {
  Map <String, dynamic> match(HttpRequest request);
}
