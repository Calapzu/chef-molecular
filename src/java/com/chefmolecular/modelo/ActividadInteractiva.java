package com.chefmolecular.modelo;

public class ActividadInteractiva {
    private int idActividad;
    private int idEscenario;
    private String tipo;      // DRAG_AND_DROP, CONSTRUCCION_MOLECULAR, etc.
    private int orden;
    private int pesoPuntaje;

    public ActividadInteractiva() {}

    public int getIdActividad() { return idActividad; }
    public void setIdActividad(int idActividad) { this.idActividad = idActividad; }

    public int getIdEscenario() { return idEscenario; }
    public void setIdEscenario(int idEscenario) { this.idEscenario = idEscenario; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public int getOrden() { return orden; }
    public void setOrden(int orden) { this.orden = orden; }

    public int getPesoPuntaje() { return pesoPuntaje; }
    public void setPesoPuntaje(int pesoPuntaje) { this.pesoPuntaje = pesoPuntaje; }
}
