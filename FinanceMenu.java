package sumis;

import java.sql.*;
import java.util.Scanner;

public class FinanceMenu {

    private final Scanner sc = new Scanner(System.in);

    public void show() {
        while (true) {
            System.out.println("\n======= FINANCE MENU =======");
            System.out.println("1. View Unpaid Fines");
            System.out.println("2. Record Payment");
            System.out.println("3. Monthly Revenue Report");
            System.out.println("4. Escalate Overdue Fines (+10%)");
            System.out.println("0. Logout");
            System.out.print("Choice: ");

            int choice = Integer.parseInt(sc.nextLine().trim());
            switch (choice) {
                case 1 -> viewUnpaidFines();
                case 2 -> recordPayment();
                case 3 -> monthlyRevenue();
                case 4 -> escalateFines();
                case 0 -> { return; }
                default -> System.out.println("Invalid option.");
            }
        }
    }

    // -- Core Finance Functions ------------------------------------------------

    private void viewUnpaidFines() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM vw_unpaid_fines LIMIT 30")) {
            System.out.printf("%n%-7s %-15s %-20s %-15s %-25s %-10s %-12s %-10s%n",
                "FineID","RegNo","OwnerName","ContactNo","ViolationType","Amount","DueDate","DaysOverdue");
            System.out.println("-".repeat(120));
            while (rs.next()) {
                System.out.printf("%-7d %-15s %-20s %-15s %-25s %-10.2f %-12s %-10d%n",
                    rs.getInt("FineID"),
                    rs.getString("RegistrationNo"),
                    rs.getString("OwnerName"),
                    rs.getString("ContactNo"),
                    rs.getString("ViolationType"),
                    rs.getDouble("Amount"),
                    rs.getDate("DueDate"),
                    rs.getInt("DaysOverdue"));
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void recordPayment() {
        try {
            System.out.print("Enter Fine ID: ");
            int fineId = Integer.parseInt(sc.nextLine().trim());
            System.out.print("Enter Amount Paid: ");
            double amount = Double.parseDouble(sc.nextLine().trim());
            System.out.print("Payment Mode (Cash/Online/Card): ");
            String mode = sc.nextLine().trim();

            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO Payment (FineID, AmountPaid, Mode) VALUES (?,?,?)")) {
                ps.setInt(1, fineId);
                ps.setDouble(2, amount);
                ps.setString(3, mode);
                ps.executeUpdate();
                conn.commit();
                System.out.println("[OK] Payment recorded. Fine status updated to Paid automatically.");
            } catch (SQLException ex) {
                conn.rollback();
                System.err.println("Payment failed, transaction rolled back: " + ex.getMessage());
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void monthlyRevenue() {
        try {
            System.out.print("Enter Year (e.g. 2026): ");
            int year = Integer.parseInt(sc.nextLine().trim());
            System.out.print("Enter Month (1-12): ");
            int month = Integer.parseInt(sc.nextLine().trim());

            String sql = """
                SELECT TO_CHAR(PaymentDate,'YYYY-MM') AS Month,
                       COUNT(PaymentID) AS TotalPayments,
                       SUM(AmountPaid) AS TotalRevenue
                FROM Payment
                WHERE EXTRACT(YEAR FROM PaymentDate) = ?
                  AND EXTRACT(MONTH FROM PaymentDate) = ?
                GROUP BY TO_CHAR(PaymentDate,'YYYY-MM')
                """;
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, year);
                ps.setInt(2, month);
                ResultSet rs = ps.executeQuery();
                System.out.printf("%n%-10s %-15s %-15s%n", "Month", "TotalPayments", "TotalRevenue");
                System.out.println("-".repeat(42));
                boolean found = false;
                while (rs.next()) {
                    found = true;
                    System.out.printf("%-10s %-15d Rs.%-12.2f%n",
                        rs.getString("Month"),
                        rs.getInt("TotalPayments"),
                        rs.getDouble("TotalRevenue"));
                }
                if (!found) System.out.println("No payments found for this period.");
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void escalateFines() {
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall("CALL sp_escalate_overdue_fines()")) {
            cs.execute();
            System.out.println("[OK] Overdue fines escalated by 10%.");
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }
}
