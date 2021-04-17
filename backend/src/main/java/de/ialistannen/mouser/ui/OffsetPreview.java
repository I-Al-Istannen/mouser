package de.ialistannen.mouser.ui;

import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Border;
import javafx.scene.layout.BorderStroke;
import javafx.scene.layout.BorderStrokeStyle;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;

public class OffsetPreview extends AnchorPane {

  private final Canvas canvas;

  public OffsetPreview() {
    canvas = new Canvas(300, 300);
    getChildren().add(canvas);
    setMaxSize(200, 200);
    setBorder(new Border(
        new BorderStroke(
            Color.TOMATO, BorderStrokeStyle.DOTTED, null, null
        )
    ));
  }

  public void setData(double dx, double dy) {
    double length = Math.sqrt(dx * dx + dy * dy);
    dx /= length;
    dy /= length;

    dx *= 100;
    dy *= 100;

    GraphicsContext context = canvas.getGraphicsContext2D();
    context.clearRect(0, 0, canvas.getWidth(), canvas.getHeight());
    context.fillOval(
        canvas.getWidth() / 2 - 2, canvas.getHeight() / 2 - 2,
        4, 4
    );

    context.setLineWidth(2);
    context.strokeLine(
        canvas.getWidth() / 2, canvas.getHeight() / 2,
        canvas.getWidth() / 2 + dx, canvas.getHeight() / 2 + dy
    );
  }
}
