package sumis;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton DB connection manager.
 * Update URL, USER, PASSWORD before running.
 */
public class DBConnection {

    private static final String URL      = "jdbc:postgresql://localhost:5432/sumis_db";
    private static final String USER     = System.getenv("SUMIS_DB_USER")     != null
                                           ? System.getenv("SUMIS_DB_USER")     : "postgres";
    private static final String PASSWORD = System.getenv("SUMIS_DB_PASSWORD") != null
                                           ? System.getenv("SUMIS_DB_PASSWORD") : "";

    private static Connection connection = null;

    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
            } catch (ClassNotFoundException e) {
                throw new SQLException("PostgreSQL JDBC Driver not found.", e);
            }
        }
        return connection;
    }

    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
        }
    }
}
