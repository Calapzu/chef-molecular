package com.chefmolecular.modelo;

public class ElementoArrastrable {
    private int idElemento;
    private int idActividad;
    private String nombre;
    private int idCategoria;        // NUEVO: llave foránea
    private String categoriaCorrecta;  // Para mantener compatibilidad (se llena desde JOIN)

    public ElementoArrastrable() {}

    public int getIdElemento() { return idElemento; }
    public void setIdElemento(int idElemento) { this.idElemento = idElemento; }

    public int getIdActividad() { return idActividad; }
    public void setIdActividad(int idActividad) { this.idActividad = idActividad; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    // NUEVO
    public int getIdCategoria() { return idCategoria; }
    public void setIdCategoria(int idCategoria) { this.idCategoria = idCategoria; }

    // Para compatibilidad con el código existente
    public String getCategoriaCorrecta() { return categoriaCorrecta; }
    public void setCategoriaCorrecta(String categoriaCorrecta) { this.categoriaCorrecta = categoriaCorrecta; }
}