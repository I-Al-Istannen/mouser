package de.ialistannen.mouser.util;

import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Robot;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;
import javafx.geometry.Point2D;

public class MouseMover {

  private final ScheduledExecutorService executorService;
  private final AtomicReference<Point2D> target;
  private final Robot robot;

  public MouseMover(Robot robot) {
    this.robot = robot;
    this.executorService = Executors.newSingleThreadScheduledExecutor(r -> {
      Thread thread = new Thread(r);
      thread.setDaemon(true);
      return thread;
    });
    this.target = new AtomicReference<>(new Point2D(0, 0));

    this.executorService.scheduleAtFixedRate(this::run, 0, 33, TimeUnit.MILLISECONDS);
  }

  private void run() {
    Point2D pointerLoc = getPointerLoc();
    Point2D currentTarget = target.get();

    // current + adjustment * 4 = target
    // adjustment               = (target - current) / 4

    Point2D adjustment = currentTarget.subtract(pointerLoc).multiply(1.0 / 4);
    Point2D newPoint = pointerLoc.add(adjustment);
    robot.mouseMove((int) Math.round(newPoint.getX()), (int) Math.round(newPoint.getY()));
  }

  private Point2D getPointerLoc() {
    Point pointerLoc = MouseInfo.getPointerInfo().getLocation();

    return new Point2D(pointerLoc.getX(), pointerLoc.getY());
  }

  public synchronized void setTarget(Point2D point) {
    target.set(point);
  }

  public void destroy() {
    executorService.shutdown();
  }
}
