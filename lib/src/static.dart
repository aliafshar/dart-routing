// Copyright (c) 2012, Google Inc
// Author: afshar@google.com (Ali Afshar)

part of routing;

class RouteStatic implements RouteComponent {

  final String prefix;
  final Path path;

  RouteStatic(this.prefix, this.path);

  Map<String, dynamic> match(HttpRequest request) {
    if (request.path.startsWith(this.prefix)) {
      var filename = request.path.substring(this.prefix.length);
      var filepath = path.join(new Path.fromNative(filename));
      return {'__filepath__': filepath};
    }
    else {
      return {'__error__': 404};
    }
  }

}
