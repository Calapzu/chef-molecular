package com.chefmolecular.modelo;

import java.time.LocalDateTime;

public class ResultadoActividad {
    private int idResultado;
    private int idActividad;
    private int idEstudiante;
    private int idProgreso;
    private int correctos;
    private int incorrectos;
    private int puntajeObtenido;
    private boolean completado;
    private LocalDateTime creadoEn;

    public ResultadoActividad() {}

    public int getIdResultado() { return idResultado; }
    public void setIdResultado(int idResultado) { this.idResultado = idResultado; }

    public int getIdActividad() { return idActividad; }
    public void setIdActividad(int idActividad) { this.idActividad = idActividad; }

    public int getIdEstudiante() { return idEstudiante; }
    public void setIdEstudiante(int idEstudiante) { this.idEstudiante = idEstudiante; }

    public int getIdProgreso() { return idProgreso; }
    public void setIdProgreso(int idProgreso) { this.idProgreso = idProgreso; }

    public int getCorrectos() { return correctos; }
    public void setCorrectos(int correctos) { this.correctos = correctos; }

    public int getIncorrectos() { return incorrectos; }
    public void setIncorrectos(int incorrectos) { this.incorrectos = incorrectos; }

    public int getPuntajeObtenido() { return puntajeObtenido; }
    public void setPuntajeObtenido(int puntajeObtenido) { this.puntajeObtenido = puntajeObtenido; }

    public boolean isCompletado() { return completado; }
    public void setCompletado(boolean completado) { this.completado = completado; }

    public LocalDateTime getCreadoEn() { return creadoEn; }
    public void setCreadoEn(LocalDateTime creadoEn) { this.creadoEn = creadoEn; }
}