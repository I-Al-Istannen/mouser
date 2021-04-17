package de.ialistannen.mouser.data;

public class PitchRollPacket {

  private final double pitch;
  private final double roll;

  public PitchRollPacket(double pitch, double roll) {
    this.pitch = pitch;
    this.roll = roll;
  }

  public double getPitch() {
    return pitch;
  }

  public double getRoll() {
    return roll;
  }

  @Override
  public String toString() {
    return "PitchRollPacket{" +
        "pitch=" + pitch +
        ", roll=" + roll +
        '}';
  }
}
