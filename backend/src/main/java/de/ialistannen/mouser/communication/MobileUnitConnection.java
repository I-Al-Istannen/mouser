package de.ialistannen.mouser.communication;

import static de.ialistannen.mouser.util.WellKnown.PACKET_SIZE;
import static de.ialistannen.mouser.util.WellKnown.RECEIVE_PORT;

import de.ialistannen.mouser.data.Packet;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.nio.ByteBuffer;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.function.Consumer;

public class MobileUnitConnection {

  private final DatagramSocket socket;
  private final Consumer<Packet> consumer;
  private final ExecutorService executor;
  private volatile boolean running;

  public MobileUnitConnection(Consumer<Packet> consumer) throws SocketException {
    this.consumer = consumer;
    this.socket = new DatagramSocket(RECEIVE_PORT);
    this.running = true;

    this.socket.setSoTimeout(250);

    this.executor = Executors.newSingleThreadExecutor(r -> {
      Thread thread = new Thread(r);
      thread.setDaemon(true);
      return thread;
    });

    executor.execute(this::run);
  }

  private void run() {
    while (running) {
      DatagramPacket packet = new DatagramPacket(new byte[PACKET_SIZE], PACKET_SIZE);
      try {
        socket.receive(packet);
        ByteBuffer buffer = ByteBuffer.wrap(packet.getData());
        consumer.accept(Packet.fromData(buffer));
      } catch (SocketTimeoutException ignored) {
      } catch (IOException e) {
        if (e.getMessage().contains("Socket closed")) {
          return;
        }
        e.printStackTrace();
      }
    }
  }

  public void destroy() {
    executor.shutdown();
    running = false;
    if (socket != null) {
      socket.close();
    }
  }
}
