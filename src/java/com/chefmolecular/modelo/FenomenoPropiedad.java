package com.chefmolecular.modelo;

public class FenomenoPropiedad {
    private int idFenomeno;
    private int idActividad;
    private String descripcion;
    private String propiedadCorrecta; // "TENSION_SUPERFICIAL", "VISCOSIDAD", "CAPILARIDAD"

    public FenomenoPropiedad() {}

    public int getIdFenomeno() {
        return idFenomeno;
    }

    public void setIdFenomeno(int idFenomeno) {
        this.idFenomeno = idFenomeno;
    }

    public int getIdActividad() {
        return idActividad;
    }

    public void setIdActividad(int idActividad) {
        this.idActividad = idActividad;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getPropiedadCorrecta() {
        return propiedadCorrecta;
    }

    public void setPropiedadCorrecta(String propiedadCorrecta) {
        this.propiedadCorrecta = propiedadCorrecta;
    }

    
}