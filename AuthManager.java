package sumis;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.*;

public class AuthManager {

    private String loggedInUser;
    private String loggedInRole;

    /**
     * Stored Password format: "<32-hex-char salt>:<sha256(salt+plaintext) hex>".
     * Salting prevents rainbow-table attacks against the UserAccount table.
     */
    private static String sha256Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    private static String generateSalt() {
        byte[] saltBytes = new byte[16];
        new SecureRandom().nextBytes(saltBytes);
        StringBuilder sb = new StringBuilder();
        for (byte b : saltBytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    /** Builds a new "salt:hash" value to store when creating a user account. */
    public static String hashPassword(String plaintext) {
        String salt = generateSalt();
        return salt + ":" + sha256Hex(salt + plaintext);
    }

    public boolean login(String username, String password) {
        String sql = "SELECT Role, Password FROM UserAccount WHERE Username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String stored = rs.getString("Password");
                String[] parts = stored.split(":", 2);
                if (parts.length == 2 && sha256Hex(parts[0] + password).equals(parts[1])) {
                    loggedInUser = username;
                    loggedInRole = rs.getString("Role");
                    return true;
                }
            }
        } catch (SQLException e) {
            System.err.println("Login error: " + e.getMessage());
        }
        return false;
    }

    public String getRole()     { return loggedInRole; }
    public String getUsername() { return loggedInUser; }
}
