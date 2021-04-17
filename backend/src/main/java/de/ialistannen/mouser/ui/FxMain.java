package de.ialistannen.mouser.ui;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class FxMain extends Application {

  @Override
  public void start(Stage primaryStage) throws Exception {
    primaryStage.setScene(new Scene(new MainWindow()));

    primaryStage.setWidth(500);
    primaryStage.setHeight(500);
    primaryStage.centerOnScreen();
    primaryStage.show();
  }
}
