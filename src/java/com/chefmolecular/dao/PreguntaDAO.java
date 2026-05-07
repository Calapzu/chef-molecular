package com.chefmolecular.dao;

import com.chefmolecular.conexion.ConexionDB;
import com.chefmolecular.modelo.Pregunta;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PreguntaDAO {

    public List<Pregunta> listarPorEscenario(int idEscenario) throws SQLException {
        String sql = "SELECT p.* FROM pregunta p "
                   + "JOIN cuestionario c ON p.id_cuestionario = c.id_cuestionario "
                   + "WHERE c.id_escenario = ? ORDER BY p.id_pregunta";
        List<Pregunta> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEscenario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        return lista;
    }

    public Pregunta buscarPorId(int idPregunta) throws SQLException {
        String sql = "SELECT * FROM pregunta WHERE id_pregunta = ?";
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idPregunta);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        }
        return null;
    }

    public int contarPorEscenario(int idEscenario) throws SQLException {
        String sql = "SELECT COUNT(*) FROM pregunta p "
                   + "JOIN cuestionario c ON p.id_cuestionario = c.id_cuestionario "
                   + "WHERE c.id_escenario = ?";
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEscenario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    private Pregunta mapear(ResultSet rs) throws SQLException {
        Pregunta p = new Pregunta();
        p.setIdPregunta(rs.getInt("id_pregunta"));
        p.setIdCuestionario(rs.getInt("id_cuestionario"));
        p.setEnunciado(rs.getString("enunciado"));
        p.setOpcionA(rs.getString("opcion_a"));
        p.setOpcionB(rs.getString("opcion_b"));
        p.setOpcionC(rs.getString("opcion_c"));
        p.setOpcionD(rs.getString("opcion_d"));
        p.setRespuestaCorrecta(rs.getInt("respuesta_correcta"));
        p.setExplicacion(rs.getString("explicacion"));
        p.setPesoPuntaje(rs.getInt("peso_puntaje"));
        return p;
    }
}