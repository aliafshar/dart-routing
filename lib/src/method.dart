// Copyright (c) 2012, Google Inc
// Author: afshar@google.com (Ali Afshar)

part of routing;

/**
 * The method component of a [Route].
 */
class RouteMethod implements RouteComponent {

  Set<String> methods;

  RouteMethod(List<String> methods) {
    this.methods = new Set.from(methods);
  }

  factory RouteMethod.fromAnything(dynamic arg) {
    if (arg is List<String>) {
      return new RouteMethod(arg);
    }
    else if (arg is String) {
      return new RouteMethod([arg]);
    }
    else throw new RouteParseError('Cannot get methods from $arg.');
  }

  factory RouteMethod.get() {
    return new RouteMethod(['GET']);
  }

  factory RouteMethod.post() {
    return new RouteMethod(['POST']);
  }

  Map<String, String> match(HttpRequest request) {
    return methods.contains(request.method) ? {'__method__': request.method}
                                            : {'__error__' : 405};
  }
}