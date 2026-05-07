package com.chefmolecular.conexion;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConexionDB {

    // Constantes para las rutas de búsqueda del properties
    private static final String PROPERTIES_FILE_FS = "conf/database-config.properties";
    private static final String PROPERTIES_FILE_CLASSPATH = "database-config.properties";

    // Variables que se cargarán desde el archivo
    private static String URL;
    private static String USUARIO;
    private static String CLAVE;

    // Bloque estático: carga el driver y luego las propiedades
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cargarPropiedades(); // <-- Carga URL, USUARIO y CLAVE desde archivo
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver MySQL no encontrado", e);
        }
    }

    private static void cargarPropiedades() {
        Properties props = new Properties();
        try (InputStream is = ConexionDB.class.getClassLoader()
                .getResourceAsStream("database-config.properties")) {
            if (is == null) {
                throw new RuntimeException("No se encontró database-config.properties en WEB-INF/classes/");
            }
            props.load(is);
            URL = props.getProperty("db.url");
            USUARIO = props.getProperty("db.user");
            CLAVE = props.getProperty("db.password");
        } catch (IOException e) {
            throw new RuntimeException("Error al leer properties", e);
        }
    }

    public static Connection obtener() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }
}
