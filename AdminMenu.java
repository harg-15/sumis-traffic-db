package sumis;

import java.sql.*;
import java.util.Scanner;

public class AdminMenu {

    private final Scanner sc = new Scanner(System.in);

    public void show() {
        while (true) {
            System.out.println("\n======= ADMIN MENU =======");
            System.out.println("1.  Add Zone");
            System.out.println("2.  Add Road");
            System.out.println("3.  Add Intersection");
            System.out.println("4.  Soft-Delete Vehicle");
            System.out.println("5.  View All Users");
            System.out.println("6.  Add User Account");
            System.out.println("7.  Rename Username");
            System.out.println("8.  Delete User Account");
            System.out.println("9.  Run All Analytics Views");
            System.out.println("10. Run Custom SQL");
            System.out.println("0.  Logout");
            System.out.print("Choice: ");

            int choice = Integer.parseInt(sc.nextLine().trim());
            switch (choice) {
                case 1  -> addZone();
                case 2  -> addRoad();
                case 3  -> addIntersection();
                case 4  -> softDeleteVehicle();
                case 5  -> viewUsers();
                case 6  -> addUser();
                case 7  -> renameUser();
                case 8  -> deleteUser();
                case 9  -> runAllAnalytics();
                case 10 -> runCustomSQL();
                case 0  -> { return; }
                default -> System.out.println("Invalid option.");
            }
        }
    }

    // -- Infrastructure --------------------------------------------------------

    private void addZone() {
        try {
            System.out.print("Zone Name: ");
            String name = sc.nextLine().trim();
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO Zone (ZoneName) VALUES (?)")) {
                ps.setString(1, name);
                ps.executeUpdate();
                System.out.println("[OK] Zone added.");
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void addRoad() {
        try {
            System.out.print("Road Name: ");
            String name = sc.nextLine().trim();
            System.out.print("Length (km): ");
            double len = Double.parseDouble(sc.nextLine().trim());
            System.out.print("Zone ID: ");
            int zoneId = Integer.parseInt(sc.nextLine().trim());
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO Road (RoadName, Length, ZoneID) VALUES (?,?,?)")) {
                ps.setString(1, name);
                ps.setDouble(2, len);
                ps.setInt(3, zoneId);
                ps.executeUpdate();
                System.out.println("[OK] Road added.");
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void addIntersection() {
        try {
            System.out.print("Intersection Name: ");
            String name = sc.nextLine().trim();
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO Intersection (IntersectionName) VALUES (?)")) {
                ps.setString(1, name);
                ps.executeUpdate();
                System.out.println("[OK] Intersection added.");
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void softDeleteVehicle() {
        try {
            System.out.print("Vehicle ID to deactivate: ");
            int vid = Integer.parseInt(sc.nextLine().trim());
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "UPDATE Vehicle SET IsActive = FALSE WHERE VehicleID = ?")) {
                ps.setInt(1, vid);
                int rows = ps.executeUpdate();
                System.out.println(rows > 0 ? "[OK] Vehicle soft-deleted." : "[FAIL] Vehicle not found.");
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    // -- User Management (Admin only) -----------------------------------------

    private void viewUsers() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(
                 "SELECT UserID, Username, Role FROM UserAccount ORDER BY UserID")) {
            System.out.printf("%n%-6s %-20s %-12s%n", "ID", "Username", "Role");
            System.out.println("-".repeat(40));
            while (rs.next()) {
                System.out.printf("%-6d %-20s %-12s%n",
                    rs.getInt("UserID"),
                    rs.getString("Username"),
                    rs.getString("Role"));
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void addUser() {
        try {
            System.out.print("Username: ");
            String uname = sc.nextLine().trim();
            System.out.print("Password: ");
            String pass = sc.nextLine().trim();
            System.out.print("Role (Admin/Officer/Finance/Analyst): ");
            String role = sc.nextLine().trim();

            String hashed = AuthManager.hashPassword(pass);

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO UserAccount (Username, Password, Role) VALUES (?,?,?)")) {
                ps.setString(1, uname);
                ps.setString(2, hashed);
                ps.setString(3, role);
                ps.executeUpdate();
                System.out.println("[OK] User account created successfully.");
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void renameUser() {
        try {
            viewUsers();
            System.out.print("\nEnter User ID to rename: ");
            int userId = Integer.parseInt(sc.nextLine().trim());
            System.out.print("Enter New Username: ");
            String newName = sc.nextLine().trim();

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "UPDATE UserAccount SET Username = ? WHERE UserID = ?")) {
                ps.setString(1, newName);
                ps.setInt(2, userId);
                int rows = ps.executeUpdate();
                if (rows > 0)
                    System.out.println("[OK] Username updated to: " + newName);
                else
                    System.out.println("[FAIL] User ID not found.");
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void deleteUser() {
        try {
            viewUsers();
            System.out.print("\nEnter User ID to delete: ");
            int userId = Integer.parseInt(sc.nextLine().trim());
            System.out.print("Are you sure? This cannot be undone. (yes/no): ");
            String confirm = sc.nextLine().trim();

            if (!confirm.equalsIgnoreCase("yes")) {
                System.out.println("Cancelled.");
                return;
            }

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "DELETE FROM UserAccount WHERE UserID = ?")) {
                ps.setInt(1, userId);
                int rows = ps.executeUpdate();
                if (rows > 0)
                    System.out.println("[OK] User account deleted.");
                else
                    System.out.println("[FAIL] User ID not found.");
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    // -- Analytics & Custom SQL ------------------------------------------------

    private void runAllAnalytics() {
        System.out.println("\n[Delegating to Analyst module]");
        new AnalystMenu().show();
    }

    private void runCustomSQL() {
        System.out.println("\nEnter your SQL query (SELECT, INSERT, UPDATE, DELETE supported):");
        System.out.print("SQL> ");
        String sql = sc.nextLine().trim();
        if (sql.isEmpty()) { System.out.println("No query entered."); return; }
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            boolean isSelect = sql.trim().toUpperCase().startsWith("SELECT");
            if (isSelect) {
                ResultSet rs = st.executeQuery(sql);
                ResultSetMetaData meta = rs.getMetaData();
                int cols = meta.getColumnCount();
                System.out.println();
                for (int i = 1; i <= cols; i++)
                    System.out.printf("%-20s", meta.getColumnName(i));
                System.out.println("\n" + "-".repeat(20 * cols));
                int rowCount = 0;
                while (rs.next()) {
                    for (int i = 1; i <= cols; i++)
                        System.out.printf("%-20s",
                            rs.getString(i) != null ? rs.getString(i) : "NULL");
                    System.out.println();
                    rowCount++;
                }
                System.out.println("\n[" + rowCount + " row(s) returned]");
            } else {
                int affected = st.executeUpdate(sql);
                System.out.println("[OK] Query executed. " + affected + " row(s) affected.");
            }
        } catch (Exception e) { System.err.println("SQL Error: " + e.getMessage()); }
    }
}
