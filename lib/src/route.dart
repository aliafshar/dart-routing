part of routing;


/**
 * A matchable route.
 *
 * This optionally matches a route and a method.
 */
class Route {

  final String name;
  final RoutePath path;
  final RouteMethod method;
  final RouteStatic static;

  /**
   * Creates a new route.
   */
  Route(this.name, {this.path, this.method, this.static});

  /**
   * Matches this route against an HTTP request.
   *
   * Returns a [RouteMatch] or [null] when the request does not match.
   */
  RouteMatch match(HttpRequest request) {
    var matchers = <RouteComponent>[this.method, this.static, this.path];
    var matchArgs = {};
    for (var matcher in matchers) {
      if (matcher != null) {
        var args = matcher.match(request);
        args.forEach((var k, var v) => matchArgs[k] = v);
      }
    }
    var match = new RouteMatch(this, name, matchArgs);
    return match;
  }
}


/**
 * A matched route.
 *
 * Contains the route and any arguments generated during match.
 */
class RouteMatch {
  final String name;
  final Route route;
  final Map<String, dynamic> args;
  final String method = 'GET';
  final String protocol = 'http';

  RouteMatch(this.route, this.name, this.args);

  int get error => args['__error__'];
  bool get isError => error != null;
  Path get filepath => args['__filepath__'];
  bool get isFile => filepath != null;
}


/**
 * A map of routes.
 */
class RouteMap {

  // The list of routes to track the order.
  List<Route> routeList;

  // The map of routes by name.
  Map<String, Route> routes;

  // The map of views by name.
  Map<String, Function> views;

  /**
   * Creates a new route map.
   */
  RouteMap() {
    views = <Function>{};
    routes = <Route>{};
    routeList = <Route>[];
  }

  /**
   * Adds a route to this map.
   */
  add(Route route) {
    routes[route.name] = route;
    routeList.add(route);
  }

  /**
   * Matches and returns the first matched route, or null if there is no match.
   */
  RouteMatch match(HttpRequest request) {
    var lastError;
    for (var route in routeList) {
      var m = route.match(request);
      if (!m.isError) {
        return m;
      }
      else {
        lastError = m;
      }
    }
    return lastError;
  }

  /**
   * Finds a view for a named route.
   */
  Function findView(RouteMatch m) {
    var name;
    if (m.isError) {
      name = m.error.toString();
    }
    else if (m.isFile) {
      name = '__static__';
    }
    else {
      name = m.name;
    }
    return views[name];
  }

}
