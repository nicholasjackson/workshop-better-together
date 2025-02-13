import java.nio.charset.StandardCharsets;
import java.util.UUID;

public class MinecraftOfflineUUID {

  public static UUID getOfflineUUID(String playerName) {
    // Create the string with the "OfflinePlayer:" prefix
    String offlinePlayerName = "OfflinePlayer:" + playerName;

    // Convert the string to bytes using UTF-8 encoding
    byte[] playerNameBytes = offlinePlayerName.getBytes(StandardCharsets.UTF_8);

    // Generate the UUID based on the bytes
    return UUID.nameUUIDFromBytes(playerNameBytes);
  }

  public static void main(String[] args) {
    // Example usage
    String playerName = args[0];
    UUID offlineUUID = getOfflineUUID(playerName);

    // Print the generated UUID
    System.out.print(offlineUUID);
  }
}