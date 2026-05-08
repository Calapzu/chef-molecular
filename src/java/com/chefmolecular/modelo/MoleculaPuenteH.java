package com.chefmolecular.modelo;

public class MoleculaPuenteH {
    private int idMolecula;
    private int idActividad;
    private String nombre;
    private String atomo;
    private boolean tieneH;
    private boolean puedeFormar;

    public MoleculaPuenteH() {}

    // Getters y Setters
    public int getIdMolecula() { return idMolecula; }
    public void setIdMolecula(int idMolecula) { this.idMolecula = idMolecula; }

    public int getIdActividad() { return idActividad; }
    public void setIdActividad(int idActividad) { this.idActividad = idActividad; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getAtomo() { return atomo; }
    public void setAtomo(String atomo) { this.atomo = atomo; }

    public boolean isTieneH() { return tieneH; }
    public void setTieneH(boolean tieneH) { this.tieneH = tieneH; }

    public boolean isPuedeFormar() { return puedeFormar; }
    public void setPuedeFormar(boolean puedeFormar) { this.puedeFormar = puedeFormar; }
}