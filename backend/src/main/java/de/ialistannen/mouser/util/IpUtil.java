package de.ialistannen.mouser.util;

import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InterfaceAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Objects;

public class IpUtil {

  /**
   * @return the <em>likely</em> broadcast address for the local network
   * @throws SocketException if bad things happen
   * @throws UnknownHostException if somehow 1.1.1.1 is not a valid host
   */
  public static InetAddress getLikelyLocalNetworkBroadcast()
      throws SocketException, UnknownHostException {
    InetAddress localAddress;
    try (DatagramSocket socket = new DatagramSocket()) {
      socket.connect(InetAddress.getByName("1.1.1.1"), 80);
      localAddress = socket.getLocalAddress();
    }

    NetworkInterface networkInterface = NetworkInterface.networkInterfaces()
        .filter(it -> it.inetAddresses().anyMatch(localAddress::equals))
        .findAny()
        .orElseThrow();

    return networkInterface.getInterfaceAddresses().stream()
        .map(InterfaceAddress::getBroadcast)
        .filter(Objects::nonNull)
        .findFirst()
        .orElseThrow();
  }
}
