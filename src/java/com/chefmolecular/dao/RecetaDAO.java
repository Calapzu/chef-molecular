package com.chefmolecular.dao;

import com.chefmolecular.conexion.ConexionDB;
import com.chefmolecular.modelo.Receta;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecetaDAO {

    public List<Receta> obtenerDesbloqueadas(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT r.*, 1 AS desbloqueada FROM receta r "
                   + "JOIN receta_estudiante re ON r.id_receta = re.id_receta "
                   + "WHERE re.id_estudiante = ? ORDER BY r.id_escenario, r.id_receta";
        List<Receta> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        System.out.println("    [BD] obtenerDesbloqueadas (recetas): " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public List<Receta> obtenerBloqueadas(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT r.*, 0 AS desbloqueada FROM receta r "
                   + "WHERE r.id_receta NOT IN ("
                   + "SELECT id_receta FROM receta_estudiante WHERE id_estudiante = ?) "
                   + "ORDER BY r.id_escenario, r.id_receta";
        List<Receta> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        System.out.println("    [BD] obtenerBloqueadas (recetas): " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public List<Receta> obtenerPorEscenario(int idEscenario) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT r.*, 0 AS desbloqueada FROM receta r WHERE r.id_escenario = ? ORDER BY r.id_receta";
        List<Receta> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEscenario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        System.out.println("    [BD] obtenerPorEscenario (recetas): " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    public void desbloquear(int idEstudiante, int idReceta) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "INSERT IGNORE INTO receta_estudiante (id_estudiante, id_receta) VALUES (?, ?)";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idReceta);
            ps.executeUpdate();
        }
        System.out.println("    [BD] desbloquearReceta: " + (System.currentTimeMillis() - inicio) + " ms");
    }

    public int contarDesbloqueadas(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT COUNT(*) FROM receta_estudiante WHERE id_estudiante = ?";
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int resultado = rs.getInt(1);
                    System.out.println("    [BD] contarDesbloqueadas (recetas): " + (System.currentTimeMillis() - inicio) + " ms");
                    return resultado;
                }
            }
        }
        return 0;
    }

    public List<Receta> listarTodasConEstado(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        String sql = "SELECT r.*, "
                   + "IF(re.id_receta IS NOT NULL, 1, 0) AS desbloqueada, "
                   + "re.fecha_desbloqueo "
                   + "FROM receta r "
                   + "LEFT JOIN receta_estudiante re "
                   + "ON r.id_receta = re.id_receta AND re.id_estudiante = ? "
                   + "ORDER BY r.id_escenario, r.id_receta";
        List<Receta> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapearConFecha(rs));
            }
        }
        System.out.println("    [BD] listarTodasConEstado (recetas): " + (System.currentTimeMillis() - inicio) + " ms");
        return lista;
    }

    private Receta mapearConFecha(ResultSet rs) throws SQLException {
        Receta r = new Receta();
        r.setIdReceta(rs.getInt("id_receta"));
        r.setIdEscenario(rs.getInt("id_escenario"));
        r.setNombre(rs.getString("nombre"));
        r.setDescripcion(rs.getString("descripcion"));
        r.setIngredientes(rs.getString("ingredientes"));
        r.setPasos(rs.getString("pasos"));
        r.setImagenUrl(rs.getString("imagen_url"));
        r.setEsOpcional(rs.getBoolean("es_opcional"));
        r.setDesbloqueada(rs.getBoolean("desbloqueada"));
        Timestamp ts = rs.getTimestamp("fecha_desbloqueo");
        if (ts != null) r.setFechaDesbloqueo(ts.toLocalDateTime());
        return r;
    }

    private Receta mapear(ResultSet rs) throws SQLException {
        Receta r = new Receta();
        r.setIdReceta(rs.getInt("id_receta"));
        r.setIdEscenario(rs.getInt("id_escenario"));
        r.setNombre(rs.getString("nombre"));
        r.setDescripcion(rs.getString("descripcion"));
        r.setIngredientes(rs.getString("ingredientes"));
        r.setPasos(rs.getString("pasos"));
        r.setImagenUrl(rs.getString("imagen_url"));
        r.setEsOpcional(rs.getBoolean("es_opcional"));
        r.setDesbloqueada(rs.getBoolean("desbloqueada"));
        return r;
    }
}