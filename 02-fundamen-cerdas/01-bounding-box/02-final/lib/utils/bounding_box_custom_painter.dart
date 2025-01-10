import 'dart:ui' as ui;

import 'package:bounding_box_app/model/detected_object.dart';
import 'package:flutter/material.dart';

// todo-02: create a CustomPainter
class BoundingBoxCustomPainter extends CustomPainter {
  // todo-03: add a list of model as a properties on CustomPainter
  final List<DetectedObject> detectedObjects;

  const BoundingBoxCustomPainter({
    required this.detectedObjects,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // todo-05: add coloring and stroke
    final Paint myPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;

    // todo-06: create a loop and draw a rect
    for (var detectedObject in detectedObjects) {
      canvas.drawRect(
        detectedObject.rect,
        myPaint..style = PaintingStyle.stroke,
      );

      // todo-07: setup text
      int roundedPercentage = (detectedObject.confidenceScore * 100).round();
      final text = "${detectedObject.text} $roundedPercentage%";

      // todo-08: draw a text
      final paragraphStyle = ui.ParagraphStyle(
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      final textStyle = ui.TextStyle(
        color: Colors.white,
        background: myPaint..style = PaintingStyle.fill,
        fontSize: 12,
      );
      final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(text);
      final paragraphConstraints = ui.ParagraphConstraints(
        width: (detectedObject.rect.right - detectedObject.rect.left).abs(),
      );
      final paragraph = paragraphBuilder.build()..layout(paragraphConstraints);

      canvas.drawParagraph(
        paragraph,
        Offset(
          detectedObject.rect.left,
          detectedObject.rect.top,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant BoundingBoxCustomPainter oldDelegate) {
    return detectedObjects != oldDelegate.detectedObjects;
  }
}
