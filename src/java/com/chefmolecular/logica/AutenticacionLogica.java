package com.chefmolecular.logica;

import com.chefmolecular.dao.EstudianteDAO;
import com.chefmolecular.dao.ProgresoDAO;
import com.chefmolecular.modelo.Estudiante;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

public class AutenticacionLogica {

    private final EstudianteDAO estudianteDAO = new EstudianteDAO();
    private final ProgresoDAO   progresoDAO   = new ProgresoDAO();

    public String cifrarSHA256(String texto) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(texto.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 no disponible", e);
        }
    }

    /**
     * Registra un estudiante nuevo.
     * @return null si éxito, mensaje de error si falla
     */
    public String registrar(String nombre, String correo, String password) {
        try {
            if (nombre == null || nombre.trim().isEmpty())   return "El nombre es obligatorio.";
            if (correo == null || correo.trim().isEmpty())   return "El correo es obligatorio.";
            if (password == null || password.length() < 6)  return "La contraseña debe tener mínimo 6 caracteres.";
            if (estudianteDAO.existeCorreo(correo))          return "Este correo ya está registrado.";

            Estudiante e = new Estudiante();
            e.setNombreCompleto(nombre.trim());
            e.setCorreo(correo);
            e.setPasswordHash(cifrarSHA256(password));

            boolean ok = estudianteDAO.registrar(e);
            if (!ok) return "Error al registrar. Intente nuevamente.";

            // Obtener el id recién creado para inicializar progreso
            Estudiante creado = estudianteDAO.buscarPorCredenciales(correo, cifrarSHA256(password));
            if (creado != null) progresoDAO.inicializarProgreso(creado.getIdEstudiante());

            return null; // éxito
        } catch (SQLException ex) {
            ex.printStackTrace();
            return "Error de base de datos: " + ex.getMessage();
        }
    }

    /**
     * Autentica un estudiante.
     * @return Estudiante si éxito, null si credenciales incorrectas
     */
    public Estudiante login(String correo, String password) throws SQLException {
        return estudianteDAO.buscarPorCredenciales(correo, cifrarSHA256(password));
    }
}
