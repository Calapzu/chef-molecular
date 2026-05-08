package com.chefmolecular.modelo;

public class PiezaMolecular {
    private int idPieza;
    private int idActividad;
    private String nombre;
    private String formula;
    private String color;

    public PiezaMolecular() {}

    public int getIdPieza() { return idPieza; }
    public void setIdPieza(int idPieza) { this.idPieza = idPieza; }

    public int getIdActividad() { return idActividad; }
    public void setIdActividad(int idActividad) { this.idActividad = idActividad; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getFormula() { return formula; }
    public void setFormula(String formula) { this.formula = formula; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
}