package de.ialistannen.mouser.ui;

import de.ialistannen.mouser.communication.AddressBroadcaster;
import de.ialistannen.mouser.communication.MobileUnitConnection;
import de.ialistannen.mouser.data.ClickPacket;
import de.ialistannen.mouser.data.Packet;
import de.ialistannen.mouser.data.PitchRollPacket;
import de.ialistannen.mouser.util.IpUtil;
import de.ialistannen.mouser.util.WellKnown;
import java.awt.AWTException;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.event.InputEvent;
import java.io.IOException;
import java.net.InetAddress;
import java.util.function.Consumer;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.control.Button;
import javafx.scene.layout.BorderPane;

public class MainWindow extends BorderPane {

  @FXML
  private Button yieldMouseButton;

  @FXML
  private Button broadcastButton;

  private AddressBroadcaster broadcaster;
  private MobileUnitConnection connection;
  private final OffsetPreview offsetPreview;

  public MainWindow() {
    offsetPreview = new OffsetPreview();

    FXMLLoader loader = new FXMLLoader(getClass().getResource("/MainWindow.fxml"));
    loader.setRoot(this);
    loader.setController(this);

    try {
      loader.load();
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
    setCenter(offsetPreview);
  }

  @FXML
  private void onBroadcast() throws Exception {
    if (broadcaster == null) {
      broadcaster = new AddressBroadcaster(
          InetAddress.getLocalHost().getHostName(),
          IpUtil.getLikelyLocalNetworkBroadcast()
      );
      broadcastButton.setText("Stop broadcasting address");
    } else {
      broadcaster.destroy();
      broadcaster = null;
      broadcastButton.setText("Broadcast my address");
    }
  }

  @FXML
  private void onYieldMouse() throws Exception {
    if (connection == null) {
      connection = new MobileUnitConnection(packetConsumer());
      yieldMouseButton.setText("Take control");
    } else {
      connection.destroy();
      connection = null;
      yieldMouseButton.setText("Yield mouse control");
    }
  }

  private Consumer<Packet> packetConsumer() throws AWTException {
    double width = Toolkit.getDefaultToolkit().getScreenSize().getWidth();
    double height = Toolkit.getDefaultToolkit().getScreenSize().getHeight();
    Robot robot = new Robot();

    return packet -> {
      if (packet instanceof ClickPacket) {
        robot.mousePress(InputEvent.BUTTON1_DOWN_MASK);
        robot.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);
      }
      if (packet instanceof PitchRollPacket pitchRollPacket) {
        Point mousePosition = MouseInfo.getPointerInfo().getLocation();

        double dx = -pitchRollPacket.getRoll();
        double dy = pitchRollPacket.getPitch();
        // Normalize it to 8 Pixels
        double length = Math.sqrt(dx * dx + dy * dy);
        dx /= length / WellKnown.MAGIC_SCALE;
        dy /= length / WellKnown.MAGIC_SCALE;

        // This whole section is a giant magic number. Values found through trial and error.
        if(length < 13) {
          dx /= Math.exp(-(length - 7)) + 2;
          dy /= Math.exp(-(length - 7)) + 2;
        }

        double newX = Math.max(0, Math.min(mousePosition.getX() + dx, width));
        double newY = Math.max(0, Math.min(mousePosition.getY() + dy, height));

        offsetPreview.setData(dx, dy);

        robot.mouseMove((int) Math.round(newX), (int) Math.round(newY));
      }
    };
  }
}
