package de.ialistannen.mouser.data;

import java.nio.ByteBuffer;

public abstract class Packet {

  public static Packet fromData(ByteBuffer buffer) {
    return switch (buffer.get()) {
      case 0 -> new PitchRollPacket(buffer.getDouble(1), buffer.getDouble(1 + 8));
      case 1 -> new ClickPacket();
      default -> throw new RuntimeException("Unknown packet. Type: " + buffer.get());
    };
  }

  public enum Type {
    CLICK,
    PITCH_ROLL
  }
}
