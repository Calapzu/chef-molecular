package com.chefmolecular.logica;

import com.chefmolecular.conexion.ConexionDB;
import com.chefmolecular.modelo.Estudiante;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RankingLogica {

    public List<Estudiante> obtenerTop10() throws SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [RankingLogica] obtenerTop10 ---");

        String sql = "SELECT * FROM estudiante ORDER BY total_estrellas DESC LIMIT 10";
        List<Estudiante> lista = new ArrayList<>();
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Estudiante e = new Estudiante();
                e.setIdEstudiante(rs.getInt("id_estudiante"));
                e.setNombreCompleto(rs.getString("nombre_completo"));
                e.setRango(rs.getString("rango"));
                e.setTotalEstrellas(rs.getInt("total_estrellas"));
                lista.add(e);
            }
        }

        System.out.println("[DAO→BD] obtenerTop10: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("------------------------------------\n");
        return lista;
    }

    public int obtenerPosicion(int idEstudiante) throws SQLException {
        long inicio = System.currentTimeMillis();
        System.out.println("\n--- [RankingLogica] obtenerPosicion ---");

        String sql = "SELECT COUNT(*) + 1 FROM estudiante "
                   + "WHERE total_estrellas > (SELECT total_estrellas FROM estudiante WHERE id_estudiante = ?)";
        int posicion = 0;
        try (Connection cn = ConexionDB.obtener();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idEstudiante);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) posicion = rs.getInt(1);
            }
        }

        System.out.println("[DAO→BD] obtenerPosicion: " + (System.currentTimeMillis() - inicio) + " ms");
        System.out.println("--------------------------------------\n");
        return posicion;
    }
}