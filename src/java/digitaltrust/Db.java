package digitaltrust;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

final class Db {

    private Db() {
    }

    static Connection getConnection() throws SQLException {
        String url = firstEnv("DB_URL", "AIVEN_DB_URL", "JDBC_DATABASE_URL");
        String user = firstEnv("DB_USER", "AIVEN_DB_USER", "JDBC_DATABASE_USERNAME");
        String password = firstEnv("DB_PASSWORD", "DB_PASS", "AIVEN_DB_PASSWORD", "JDBC_DATABASE_PASSWORD");

        if (isBlank(url) || isBlank(user) || isBlank(password)) {
            throw new IllegalStateException(
                "Database environment variables are missing. Set DB_URL, DB_USER and DB_PASSWORD.");
        }

        return DriverManager.getConnection(url, user, password);
    }

    static void loadDriver() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL JDBC driver is not available.", e);
        }
    }

    private static String firstEnv(String... names) {
        for (String name : names) {
            String value = System.getenv(name);
            if (!isBlank(value)) {
                return value.trim();
            }
        }
        return "";
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
