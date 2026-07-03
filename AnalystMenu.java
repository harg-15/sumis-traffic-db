package sumis;

import java.sql.*;
import java.util.Scanner;

public class AnalystMenu {

    private final Scanner sc = new Scanner(System.in);

    public void show() {
        while (true) {
            System.out.println("\n======= ANALYST MENU =======");
            System.out.println("1. Zone-wise Violation Report");
            System.out.println("2. Accident Hotspots");
            System.out.println("3. Vehicle Risk Scores");
            System.out.println("4. Congestion Trends (Last 7 Days)");
            System.out.println("5. Anomaly Detection - High Risk Vehicles");
            System.out.println("0. Logout");
            System.out.print("Choice: ");

            int choice = Integer.parseInt(sc.nextLine().trim());
            switch (choice) {
                case 1  -> zoneViolations();
                case 2  -> accidentHotspots();
                case 3  -> vehicleRiskScores();
                case 4  -> congestionTrends();
                case 5  -> anomalyDetection();
                case 0  -> { return; }
                default -> System.out.println("Invalid option.");
            }
        }
    }

    // -- Core Analytics Functions ----------------------------------------------

    private void zoneViolations() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM vw_zone_violations")) {
            System.out.printf("%n%-20s %-18s %-20s%n",
                "ZoneName","TotalViolations","TotalFines(Rs.)");
            System.out.println("-".repeat(60));
            while (rs.next()) {
                System.out.printf("%-20s %-18d Rs.%-15.2f%n",
                    rs.getString("ZoneName"),
                    rs.getInt("TotalViolations"),
                    rs.getDouble("TotalFinesGenerated"));
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void accidentHotspots() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM vw_accident_hotspots")) {
            System.out.printf("%n%-25s %-14s %-12s %-14s %-10s%n",
                "Intersection","TotalAccidents","High","Medium","Low");
            System.out.println("-".repeat(77));
            while (rs.next()) {
                System.out.printf("%-25s %-14d %-12d %-14d %-10d%n",
                    rs.getString("IntersectionName"),
                    rs.getInt("TotalAccidents"),
                    rs.getInt("HighSeverity"),
                    rs.getInt("MediumSeverity"),
                    rs.getInt("LowSeverity"));
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void vehicleRiskScores() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(
                 "SELECT * FROM vw_vehicle_risk_scores ORDER BY RiskScore DESC LIMIT 15")) {
            System.out.printf("%n%-15s %-20s %-14s %-12s %-10s%n",
                "RegNo","OwnerName","Violations","UnpaidFines","RiskScore");
            System.out.println("-".repeat(73));
            while (rs.next()) {
                System.out.printf("%-15s %-20s %-14d %-12d %-10d%n",
                    rs.getString("RegistrationNo"),
                    rs.getString("OwnerName"),
                    rs.getInt("TotalViolations"),
                    rs.getInt("UnpaidFines"),
                    rs.getInt("RiskScore"));
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void congestionTrends() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM vw_congestion_trend")) {
            System.out.printf("%n%-20s %-12s %-16s %-14s %-16s%n",
                "Road","Date","AvgVehicles","PeakVehicles","TypicalCongestion");
            System.out.println("-".repeat(80));
            while (rs.next()) {
                System.out.printf("%-20s %-12s %-16d %-14d %-16s%n",
                    rs.getString("RoadName"),
                    rs.getDate("LogDate"),
                    rs.getInt("AvgVehicleCount"),
                    rs.getInt("PeakVehicleCount"),
                    rs.getString("TypicalCongestion"));
            }
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }

    private void anomalyDetection() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM vw_anomaly_vehicles")) {
            System.out.printf("%n%-15s %-20s %-14s %-14s %-12s%n",
                "RegNo","OwnerName","Violations","SysAverage","Ratio");
            System.out.println("-".repeat(77));
            boolean found = false;
            while (rs.next()) {
                found = true;
                System.out.printf("%-15s %-20s %-14d %-14.2f %-12.2f%n",
                    rs.getString("RegistrationNo"),
                    rs.getString("OwnerName"),
                    rs.getInt("ViolationCount"),
                    rs.getDouble("SystemAverage"),
                    rs.getDouble("RatioToAvg"));
            }
            if (!found) System.out.println("No anomalous vehicles detected.");
        } catch (Exception e) { System.err.println("Error: " + e.getMessage()); }
    }
}
