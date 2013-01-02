// Copyright (c) 2012, Google Inc
// Author: afshar@google.com (Ali Afshar)

part of routing;

/**
 * A segment of a [RoutePath].
 */
abstract class RouteSegment {

  // Key of segment.
  String key;

  /**
   * Parses a path component into a segment.
   */
  dynamic parse(String value);

  /**
   * Builds a path component from a segment.
   */
  String build(Map<String, dynamic> args);
}


/**
 * A constant route path segment.
 *
 * Constant segments are simply matched as a string, and contain no variables.
 */
class RouteConstantSegment implements RouteSegment {

  // Key of segment.
  final String key;

  /**
   * Creates a new named segment.
   */
  RouteConstantSegment(this.key);

  /**
   * Creates a new named segment.
   */
  RouteConstantSegment.fromSegment(this.key);

  /**
   * Parses a string component.
   *
   * For [RouteConstantSegment]s this returns whether the component matches
   * the given component.
   */
  dynamic parse(String value) {
    if (value == this.key) {
      return this.key;
    }
    else {
      return null;
    }
  }

  /**
   * Builds a path component from this segment.
   *
   * For constant segments, this is the name of the segment.
   */
  String build(Map<String, dynamic> args) {
    return key;
  }

}


/**
 * Parses an integer, returning the integer on success, or [null] on failure.
 */
int intParser(String value) {
  try {
    return int.parse(value);
  } on FormatException {
    return null;
  }
}


/**
 * A variable route path segment.
 *
 * Variable segments are defined as a variable name, and optional type (default
 * is String), for example:
 *
 *     // A segment containing a variable named `name`.
 *     var s = new RouteVariableSegment.fromSegment('<name>');
 *
 *     // A segment containing an integer variable named `blogid`.
 *     var s = new RouteVariableSegment.fromSegment('<int:blogid>');
 */
class RouteVariableSegment implements RouteSegment {

  // Key of segment. In variable segments, this key becomes the argument name.
  final String key;
  final String type;

  final Map<String, Function> typeMap = {
    'str': (String s) => s,
    'int': intParser,
  };

  RouteVariableSegment(this.key, this.type);

  /**
   * Creates a new variable segment from a string.
   */
  factory RouteVariableSegment.fromSegment(String seg) {
    var actualName = seg.substring(1, seg.length - 1);
    var parts = actualName.split(':');
    if (parts.length == 1) {
      return new RouteVariableSegment(parts[0], 'str');
    }
    else {
      return new RouteVariableSegment(parts[1], parts[0]);
    }
  }

  /**
   * Parses a string component.
   *
   * For [RouteVariableSegment]s this returns the parsed value, or [null] if
   * the value does not match.
   */
  dynamic parse(String value) {
    if (typeMap.containsKey(type)) {
      Function parser = typeMap[type];
      return parser(value);
    }
    return null;
  }

  /**
   * Builds a path component from this segment.
   *
   * For variable segments, this returns a <key, value> map or raises an error
   * on failure if incorrect/missing arguments are providedd.
   */
  String build(Map<String, dynamic> args) {
    if (args.containsKey(key)) {
      return args[key].toString();
    }
    else {
      throw new RouteBuildError('Missing argument "$key"');
    }
  }

}




/**
 * The path component of a [Route].
 */
class RoutePath implements RouteComponent {

  // The list of segments in this route.
  final List<RouteSegment> segments;

  /**
   * Creates a new path from a list of [segments].
   */
  RoutePath(this.segments);

  /**
   * Creates a new [RoutePath] from a string path.
   */
  factory RoutePath.fromPath(String path) {
    return new RoutePath(parse(path));
  }

  /**
   * Parses a path into a list of segments.
   */
  static List<RouteSegment> parse(String path) {
    final segs = <RouteSegment>[];
    for (String value in split(path)) {
      segs.add(parseSegment(value));
    }
    return segs;
  }

  /*
   * Splits a path into its components.
   */
  static List<String> split(String path) {
    if (path.startsWith('/')) {
      path = path.substring(1, path.length);
    }
    return path.split('/');
  }

  /*
   * Parses a path component into the correct type of [RouteSegment].
   */
  static RouteSegment parseSegment(String value) {
    if (value.startsWith('<')) {
      return new RouteVariableSegment.fromSegment(value);
    }
    else {
      return new RouteConstantSegment.fromSegment(value);
    }
  }

  /**
   * Builds a path from given [args].
   */
  String build([Map<String, dynamic> args]) {
    if (!?args) {
      args = <dynamic>{};
    }
    var builtSegments = <String>[''];
    for (RouteSegment segment in segments) {
      builtSegments.add(segment.build(args));
    }
    return Strings.join(builtSegments, '/');
  }

  /**
   * Matches the [RoutePath] against a given [path].
   *
   * On success, this returns arguments for the route. On failure returns
   * [null].
   */
  Map<String, dynamic> match(HttpRequest request) {
    var path = request.path;
    var pathsegments = split(path);
    if (pathsegments.length != segments.length) {
      return null;
    }
    var parts = zip(pathsegments, segments);
    var args = <dynamic>{};
    for (Tuple<String, RouteSegment> part in parts) {
      var arg = part.snd.parse(part.fst);
      if (arg != null) {
        if (part.snd is RouteVariableSegment) {
          args[part.snd.key] = arg;
        }
      }
      else {
        return null;
      }
    }
    return args;
  }
}
