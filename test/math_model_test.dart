// ============================================
// ФАЙЛ: test/math_model_test.dart
// ЧТО ДЕЛАЕТ: тесты всех классов математической модели
// ============================================

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_tool/core/constants.dart';
import 'package:math_tool/core/math_model/math_angle.dart';
import 'package:math_tool/core/math_model/math_expression.dart';
import 'package:math_tool/core/math_model/math_point.dart';
import 'package:math_tool/core/math_model/math_segment.dart';
import 'package:math_tool/core/math_model/circle.dart';
import 'package:math_tool/core/math_model/polygon.dart';
import 'package:math_tool/core/math_model/triangle.dart';

void main() {
  // ─── MathPoint ──────────────────────────────────────────────────────────────

  group('MathPoint', () {
    test('distanceTo: (0,0) → (3,4) = 5.0', () {
      const a = MathPoint(x: 0, y: 0);
      const b = MathPoint(x: 3, y: 4);
      expect(a.distanceTo(b), closeTo(5.0, kEpsilon));
    });

    test('midpointTo: (0,0) и (4,0) → (2,0)', () {
      const a = MathPoint(x: 0, y: 0);
      const b = MathPoint(x: 4, y: 0);
      final mid = a.midpointTo(b);
      expect(mid.x, closeTo(2.0, kEpsilon));
      expect(mid.y, closeTo(0.0, kEpsilon));
    });

    test('== : одинаковые координаты → равны', () {
      const a = MathPoint(x: 1.5, y: 2.5);
      const b = MathPoint(x: 1.5, y: 2.5);
      expect(a, equals(b));
    });
  });

  // ─── MathSegment ────────────────────────────────────────────────────────────

  group('MathSegment', () {
    test('length: (0,0)→(3,4) = 5.0', () {
      const seg = MathSegment(
        start: MathPoint(x: 0, y: 0),
        end: MathPoint(x: 3, y: 4),
      );
      expect(seg.length(), closeTo(5.0, kEpsilon));
    });

    test('containsPoint: середина лежит на отрезке', () {
      const seg = MathSegment(
        start: MathPoint(x: 0, y: 0),
        end: MathPoint(x: 4, y: 0),
      );
      const mid = MathPoint(x: 2, y: 0);
      expect(seg.containsPoint(mid), isTrue);
    });

    test('intersectsWith: пересекающиеся отрезки → точка не null', () {
      // Отрезок по горизонтали и по вертикали — пересекаются в (2, 2)
      const h = MathSegment(
        start: MathPoint(x: 0, y: 2),
        end: MathPoint(x: 4, y: 2),
      );
      const v = MathSegment(
        start: MathPoint(x: 2, y: 0),
        end: MathPoint(x: 2, y: 4),
      );
      final intersection = h.intersectsWith(v);
      expect(intersection, isNotNull);
      expect(intersection!.x, closeTo(2.0, kEpsilon));
      expect(intersection.y, closeTo(2.0, kEpsilon));
    });
  });

  // ─── MathAngle ──────────────────────────────────────────────────────────────

  group('MathAngle', () {
    // Угол 90° — вершина в (0,0), лучи по осям X и Y
    const angle90 = MathAngle(
      vertex: MathPoint(x: 0, y: 0),
      pointA: MathPoint(x: 1, y: 0),
      pointB: MathPoint(x: 0, y: 1),
    );

    test('degrees: угол между осями X и Y = 90°', () {
      expect(angle90.degrees(), closeTo(90.0, 1e-6));
    });

    test('isRight: прямой угол распознаётся', () {
      expect(angle90.isRight(), isTrue);
    });
  });

  // ─── MathExpression ─────────────────────────────────────────────────────────

  group('MathExpression', () {
    test('evaluate: x^2+1 при x=2 → 5.0', () {
      final expr = MathExpression.fromString('x^2+1');
      expect(expr.evaluate(2.0), closeTo(5.0, kEpsilon));
    });

    test('isEquivalentTo: 2*(x+1) эквивалентно 2*x+2', () {
      final a = MathExpression.fromString('2*(x+1)');
      final b = MathExpression.fromString('2*x+2');
      expect(a.isEquivalentTo(b), isTrue);
    });

    test('isValid: "x+" невалидно', () {
      final expr = MathExpression.fromString('x+');
      expect(expr.isValid(), isFalse);
    });
  });

  // ─── Triangle ───────────────────────────────────────────────────────────────

  group('Triangle', () {
    // Прямоугольный треугольник с катетами 4 и 3
    const right = Triangle(
      pointA: MathPoint(x: 0, y: 0),
      pointB: MathPoint(x: 4, y: 0),
      pointC: MathPoint(x: 0, y: 3),
    );

    test('area: катеты 4 и 3 → площадь 6.0', () {
      expect(right.area(), closeTo(6.0, kEpsilon));
    });

    test('isRight: прямоугольный треугольник распознаётся', () {
      expect(right.isRight(), isTrue);
    });

    test('type: равносторонний треугольник определяется верно', () {
      const side = 2.0;
      final h = side * sqrt(3) / 2;
      final equilateral = Triangle(
        pointA: const MathPoint(x: 0, y: 0),
        pointB: const MathPoint(x: side, y: 0),
        pointC: MathPoint(x: side / 2, y: h),
      );
      expect(equilateral.type(), equals('равносторонний'));
    });
  });

  // ─── Circle ─────────────────────────────────────────────────────────────────

  group('Circle', () {
    const unit = Circle(
      center: MathPoint(x: 0, y: 0),
      radius: 1.0,
    );

    test('area: радиус 1 → π', () {
      expect(unit.area(), closeTo(pi, kEpsilon));
    });

    test('contains: центр лежит внутри', () {
      expect(unit.contains(const MathPoint(x: 0, y: 0)), isTrue);
    });

    test('containsOnBoundary: точка на радиусе лежит на границе', () {
      expect(unit.containsOnBoundary(const MathPoint(x: 1, y: 0)), isTrue);
    });
  });

  // ─── Polygon ────────────────────────────────────────────────────────────────

  group('Polygon', () {
    // Квадрат 2×2 с центром в (1,1)
    const square = Polygon(
      points: [
        MathPoint(x: 0, y: 0),
        MathPoint(x: 2, y: 0),
        MathPoint(x: 2, y: 2),
        MathPoint(x: 0, y: 2),
      ],
    );

    test('area: квадрат 2×2 → площадь 4.0', () {
      expect(square.area(), closeTo(4.0, kEpsilon));
    });

    test('contains: центр квадрата (1,1) внутри', () {
      expect(square.contains(const MathPoint(x: 1, y: 1)), isTrue);
    });

    test('isConvex: квадрат выпуклый', () {
      expect(square.isConvex(), isTrue);
    });
  });
}
