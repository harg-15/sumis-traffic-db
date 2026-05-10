package sumis;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

public class AuthManager {

    private String loggedInUser;
    private String loggedInRole;

    /**
     * Hashes a plaintext password using SHA-256.
     * Usage: when creating a new user, store hashPassword(plaintext) in DB.
     */
    public static String hashPassword(String plaintext) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(plaintext.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    public boolean login(String username, String password) {
        String hashed = hashPassword(password);
        String sql = "SELECT Role FROM UserAccount WHERE Username = ? AND Password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, hashed);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                loggedInUser = username;
                loggedInRole = rs.getString("Role");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Login error: " + e.getMessage());
        }
        return false;
    }

    public String getRole()     { return loggedInRole; }
    public String getUsername() { return loggedInUser; }
}
