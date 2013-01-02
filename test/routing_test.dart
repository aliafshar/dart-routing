
import "package:unittest/unittest.dart";
import "package:routing/routing.dart";

void main() {

  group('VariableSegment', () {

    test('Parse with type.', () {
      RouteVariableSegment v = new RouteVariableSegment.fromSegment('<int:a>');
      expect(
          v.key,
          equals('a')
      );
      expect(
          'int',
          equals(v.type)
      );
    });

    test('Parse default type.', () {
      RouteVariableSegment v = new RouteVariableSegment.fromSegment('<a>');
      expect(
          'a',
          equals(v.key)
      );
      expect(
          'str',
          equals(v.type)
      );
    });

    test('Parse int.', () {
      RouteVariableSegment v = new RouteVariableSegment.fromSegment('<int:a>');
      expect(
          1,
          equals(v.parse('1'))
      );
    });

    test('Parse bad int.', () {
      RouteVariableSegment v = new RouteVariableSegment.fromSegment('<int:a>');
      expect(
          null,
          equals(v.parse('banana'))
      );
    });

    test('Build int.', () {
      RouteVariableSegment v = new RouteVariableSegment.fromSegment('<int:a>');
      expect(
        '1',
        equals(v.build({'a': 1}))
      );
    });

    test('Build str.', () {
      RouteVariableSegment v = new RouteVariableSegment.fromSegment('<a>');
      expect(
        'banana',
        equals(v.build({'a': 'banana'}))
      );
    });

    test('Build missing arg.', () {
      RouteVariableSegment v = new RouteVariableSegment.fromSegment('<int:a>');
      expect(
          () => v.build({}),
          throwsA(new isInstanceOf<RouteBuildError>())
      );
    });
  });

  group('ConstantSegment', () {
    test('Parse.', () {
      var s = new RouteConstantSegment.fromSegment('a');
      expect(
        s.key,
        equals('a')
      );
    });

    test('Build args.', () {
      var s = new RouteConstantSegment.fromSegment('a');
      expect(
        s.build({'a': 'b'}),
        equals('a')
      );
    });

    test('Build no args.', () {
      var s = new RouteConstantSegment.fromSegment('a');
      expect(
        s.build({}),
        equals('a')
      );
    });

    test('Construct.', () {
      var s = new RouteConstantSegment('a');
      expect(
        s.key,
        equals('a')
      );
    });
  });

  group('RoutePath', () {

    test('Segment length constant.', () {
      var path = '/a/b/c';
      var routePath = new RoutePath.fromPath(path);
      expect(
          routePath.segments,
          hasLength(3)
      );
    });

    test('Segment length variable.', () {
      var path = '/<a>/<b>/<c>';
      var routePath = new RoutePath.fromPath(path);
      expect(
          routePath.segments,
          hasLength(3)
      );
    });

    test('Segment length mixed.', () {
      var path = '/<a>/b/<c>/d';
      var routePath = new RoutePath.fromPath(path);
      expect(
          routePath.segments,
          hasLength(4)
      );
    });

    test('Segment value constant.', () {
      var path = '/<a>/b/<c>/d';
      var routePath = new RoutePath.fromPath(path);
      expect(
          routePath.segments[1],
          new isInstanceOf<RouteConstantSegment>()
      );
    });

    test('Segment value variable.', () {
      var path = '/<a>/b/<c>/d';
      var routePath = new RoutePath.fromPath(path);
      expect(
          routePath.segments[0],
          new isInstanceOf<RouteVariableSegment>()
      );
    });

    test('Build constants no args.', () {
      var path = '/a/b/c';
      var routePath = new RoutePath.fromPath(path);
      expect(
          routePath.build(),
          equals(path)
      );
    });

    test('Build constants args.', () {
      var path = '/a/b/c';
      var routePath = new RoutePath.fromPath(path);
      expect(
          routePath.build({'a' : 'banana'}),
          equals(path)
      );
    });

    test('Build variables args.', () {
      var path = '/a/<b>';
      var routePath = new RoutePath.fromPath(path);
      expect(
          routePath.build({'b': 'c'}),
          equals('/a/c')
      );
    });

    test('Build variables missing args.', () {
      var path = '/a/<b>';
      var routePath = new RoutePath.fromPath(path);
      expect(
          routePath.build,
          throwsA(new isInstanceOf<RouteBuildError>())
      );
    });


  });

  group('Route', () {

    test('Path match', () {

      var route = new Route('index', path: new RoutePath.fromPath('/'));
      route.match();

    });


  });
}