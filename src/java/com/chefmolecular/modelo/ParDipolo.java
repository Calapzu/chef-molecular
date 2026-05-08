package com.chefmolecular.modelo;

import java.util.Objects;

public class ParDipolo {

    private int idPar;
    private int idActividad;
    private String extremoPositivo;
    private String extremoNegativo;

    public ParDipolo() {
    }

    public int getIdPar() {
        return idPar;
    }

    public void setIdPar(int idPar) {
        this.idPar = idPar;
    }

    public int getIdActividad() {
        return idActividad;
    }

    public void setIdActividad(int idActividad) {
        this.idActividad = idActividad;
    }

    public String getExtremoPositivo() {
        return extremoPositivo;
    }

    public void setExtremoPositivo(String extremoPositivo) {
        this.extremoPositivo = extremoPositivo;
    }

    public String getExtremoNegativo() {
        return extremoNegativo;
    }

    public void setExtremoNegativo(String extremoNegativo) {
        this.extremoNegativo = extremoNegativo;
    }

    @Override
    public int hashCode() {
        return Objects.hash(extremoPositivo, extremoNegativo);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        ParDipolo that = (ParDipolo) o;
        return Objects.equals(extremoPositivo, that.extremoPositivo)
                && Objects.equals(extremoNegativo, that.extremoNegativo);
    }

}
