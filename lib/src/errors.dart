// Copyright (c) 2012, Google Inc
// Author: afshar@google.com (Ali Afshar)

part of routing;

/**
 * The error that is thrown when a route cannot be parsed.
 */
class RouteParseError implements Exception {
  final String prefix = 'Error parsing route.';
  final String msg;
  const RouteParseError([this.msg]);
  String toString() => msg == null ? prefix : '$prefix $msg';
}


/**
 * The error that is thrown when a route cannot be built.
 */
class RouteBuildError implements Exception {
  final String prefix = 'Error building route.';
  final String msg;
  const RouteBuildError([this.msg]);
  String toString() => msg == null ? prefix : '$prefix $msg';
}