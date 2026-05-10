package sumis;
import java.util.Scanner;

/**
 * SUMIS - Smart Urban Mobility Intelligence System
 * Main Entry Point
 *
 * Prerequisites:
 *   1. PostgreSQL running with database 'sumis_db'
 *   2. Run SQL scripts in order: 01_schema → 02_triggers → 03_views → 04_seed
 *   3. Add postgresql-42.x.x.jar to classpath
 *
 * Compile:  javac -cp .:postgresql-42.7.9.jar *.java -d out/
 * Run:      java  -cp out:postgresql-42.7.9.jar sumis.Main
 */
public class Main {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        AuthManager auth = new AuthManager();

        System.out.println("╔══════════════════════════════════════════════════╗");
        System.out.println("║   SMART URBAN MOBILITY INTELLIGENCE SYSTEM       ║");
        System.out.println("║   SUMIS  |  Traffic Enforcement System           ║");
        System.out.println("╚══════════════════════════════════════════════════╝");

        while (true) {
            System.out.println("\n--- LOGIN ---");
            System.out.print("Username: ");
            String username = sc.nextLine().trim();

            if (username.equalsIgnoreCase("exit")) {
                System.out.println("Goodbye.");
                break;
            }

            System.out.print("Password: ");
            String password = sc.nextLine().trim();

            if (auth.login(username, password)) {
                System.out.println("\n Welcome, " + auth.getUsername() + " [" + auth.getRole() + "]");

                switch (auth.getRole()) {
                    case "Admin"   -> new AdminMenu().show();
                    case "Officer" -> new OfficerMenu().show();
                    case "Finance" -> new FinanceMenu().show();
                    case "Analyst" -> new AnalystMenu().show();
                    default        -> System.out.println("Unknown role. Contact Admin.");
                }
            } else {
                System.out.println(" Invalid credentials. Try again.");
            }
        }

        DBConnection.closeConnection();
    }
}
