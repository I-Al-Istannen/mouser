package de.ialistannen.mouser.communication;

import de.ialistannen.mouser.util.WellKnown;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class AddressBroadcaster {

  private final String name;
  private final ScheduledExecutorService executor;
  private final DatagramSocket socket;

  public AddressBroadcaster(String name, InetAddress broadcastAddress) throws SocketException {
    this.name = name;

    socket = new DatagramSocket();
    socket.connect(broadcastAddress, WellKnown.DISCOVER_PORT);

    executor = Executors.newSingleThreadScheduledExecutor(r -> {
      Thread thread = new Thread(r);
      thread.setDaemon(true);
      return thread;
    });

    executor.scheduleAtFixedRate(this::broadcast, 500, 5000, TimeUnit.MILLISECONDS);
  }

  private void broadcast() {
    try {
      byte[] bytes = name.getBytes(StandardCharsets.UTF_8);
      socket.send(new DatagramPacket(bytes, bytes.length));
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  /**
   * Destroys this broadcaster, causing it to stop sending discovery packets. This object can not be
   * reused.
   */
  public void destroy() {
    executor.shutdown();
    socket.close();
  }
}
