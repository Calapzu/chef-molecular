<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.ActividadInteractiva,
         com.chefmolecular.modelo.CategoriaActividad,
         com.chefmolecular.modelo.ElementoArrastrable,
         com.chefmolecular.modelo.ProgresoEscenario,
         com.chefmolecular.modelo.ParDipolo,
         com.chefmolecular.modelo.MoleculaPuenteH,
         com.chefmolecular.modelo.PreguntaSimulacionEstados,
         com.chefmolecular.modelo.PreguntaSimulacionEbullicion,
         com.chefmolecular.modelo.FenomenoPropiedad,
         java.util.List" %>
<%
    ActividadInteractiva actividad = (ActividadInteractiva) request.getAttribute("actividad");
    List<ActividadInteractiva> actividades = (List<ActividadInteractiva>) request.getAttribute("actividades");
    List<ElementoArrastrable> elementos = (List<ElementoArrastrable>) request.getAttribute("elementos");
    List<CategoriaActividad> categorias = (List<CategoriaActividad>) request.getAttribute("categorias");
    int actividadIdx = (int) request.getAttribute("actividadIdx");
    int totalActividades = (int) request.getAttribute("totalActividades");
    int idEscenario = (int) request.getAttribute("idEscenario");
    ProgresoEscenario progreso = (ProgresoEscenario) request.getAttribute("progreso");
    boolean yaCompletada = (boolean) request.getAttribute("yaCompletada");
    String nombreEscenario = "";
    if (idEscenario == 1) nombreEscenario = "La Cocina Fría — Dispersión de London";
    else if (idEscenario == 2) nombreEscenario = "La Sala de Salsas — Dipolo-dipolo";
    else if (idEscenario == 3) nombreEscenario = "El Taller del Merengue — Puentes de hidrógeno";
    else if (idEscenario == 4) nombreEscenario = "El Horno y el Congelador — Estados de la materia";
    else if (idEscenario == 5) nombreEscenario = "El Bar Molecular — Propiedades de los líquidos";
    else if (idEscenario == 6) nombreEscenario = "La Olla a Presión — Presión de vapor";
    else nombreEscenario = "Escenario " + idEscenario;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chef Molecular — Actividad | <%= nombreEscenario%></title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg-base: #0C0702; --bg-card: #110D06; --border: #2E2010;
            --text-ppal: #F5ECD7; --text-dim: rgba(245,236,215,0.3);
            --cobre: #C87A2C; --dorado: #D4A438; --correcto: #4CAF50; --incorrecto: #f44336;
        }
        body.dia {
            --bg-base: #EDE8DF; --bg-card: #FFFFFF; --border: #D8CDB8;
            --text-ppal: #1C1208; --text-dim: rgba(28,18,8,0.45);
            --cobre: #9B5515; --dorado: #8A6A00;
        }
        body { font-family: 'DM Sans', sans-serif; background: var(--bg-base); color: var(--text-ppal); min-height: 100vh; transition: background 0.3s, color 0.3s; }
        .navbar { background: var(--bg-card); border-bottom: 1px solid var(--border); padding: 0 40px; display: flex; align-items: center; justify-content: space-between; height: 64px; position: sticky; top: 0; z-index: 100; }
        .navbar-marca { display: flex; align-items: center; gap: 14px; }
        .marca-icono { width: 34px; height: 34px; background: var(--cobre); border-radius: 8px; display: flex; align-items: center; justify-content: center; }
        .marca-icono svg { width: 18px; height: 18px; fill: #F5ECD7; }
        .marca-nombre { font-family: 'Playfair Display', serif; font-size: 1.1rem; font-weight: 700; }
        .marca-nombre span { color: var(--cobre); font-style: italic; }
        .navbar-nav { display: flex; align-items: center; gap: 6px; }
        .nav-link { display: flex; align-items: center; gap: 6px; padding: 7px 14px; border-radius: 6px; text-decoration: none; font-size: 12px; color: var(--text-dim); border: 1px solid transparent; transition: all 0.2s; }
        .nav-link:hover { color: var(--text-ppal); background: rgba(200,122,44,0.06); border-color: var(--border); }
        .nav-salir { color: rgba(200,122,44,0.7); border-color: rgba(200,122,44,0.2); }
        .btn-tema { display: flex; align-items: center; gap: 6px; padding: 7px 14px; border-radius: 6px; font-size: 12px; color: var(--text-dim); background: none; border: 1px solid var(--border); cursor: pointer; }
        .contenedor { max-width: 900px; margin: 0 auto; padding: 48px 24px; }
        .progreso-actividades { display: flex; align-items: center; justify-content: center; gap: 12px; margin-bottom: 32px; flex-wrap: wrap; }
        .progreso-paso { display: flex; align-items: center; gap: 8px; }
        .paso-indicador { width: 32px; height: 32px; border-radius: 50%; background: var(--bg-card); border: 2px solid var(--border); display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: bold; color: var(--text-dim); }
        .paso-indicador.activo { border-color: var(--cobre); background: var(--cobre); color: white; }
        .paso-indicador.completado { border-color: #4CAF50; background: #4CAF50; color: white; }
        .paso-linea { width: 40px; height: 2px; background: var(--border); }
        .btn-accion { background: var(--cobre); color: white; border: none; border-radius: 8px; padding: 12px 24px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; margin-top: 24px; }
        .btn-accion:hover { background: #D98A3C; transform: translateY(-1px); }
        .btn-accion:disabled { background: var(--text-dim); cursor: not-allowed; }
        .btn-opcion { padding: 10px 16px; background: var(--bg-card); border: 2px solid var(--cobre); color: var(--text-ppal); border-radius: 8px; font-size: 14px; cursor: pointer; transition: all 0.2s; font-family: 'DM Sans', sans-serif; }
        .btn-opcion:hover { background: rgba(200,122,44,0.1); }
        .feedback { margin-top: 20px; padding: 16px; border-radius: 8px; display: none; }
        .feedback.success { background: rgba(76,175,80,0.1); border-left: 4px solid #4CAF50; display: block; color: #4CAF50; }
        .feedback.error { background: rgba(244,67,54,0.1); border-left: 4px solid #f44336; display: block; color: #f44336; }
        @media (max-width: 640px) { .navbar { padding: 0 16px; } .contenedor { padding: 32px 16px; } }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-marca">
            <div class="marca-icono">
                <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/></svg>
            </div>
            <span class="marca-nombre">Chef <span>Molecular</span></span>
        </div>
        <div class="navbar-nav">
            <a href="${pageContext.request.contextPath}/menu" class="nav-link">Menú</a>
            <a href="${pageContext.request.contextPath}/perfil" class="nav-link">Perfil</a>
            <a href="${pageContext.request.contextPath}/libroRecetas" class="nav-link">Recetas</a>
            <a href="${pageContext.request.contextPath}/ranking" class="nav-link">Ranking</a>
            <button class="btn-tema" id="btnTema" onclick="toggleTema()">🌙 Noche</button>
            <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-salir">Salir</a>
        </div>
    </nav>

    <div class="contenedor">
        <div class="progreso-actividades">
            <% for (int i = 0; i < totalActividades; i++) {%>
            <div class="progreso-paso">
                <div class="paso-indicador <%= (i < actividadIdx) ? "completado" : (i == actividadIdx) ? "activo" : ""%>">
                    <%= i + 1%>
                </div>
                <% if (i < totalActividades - 1) {%>
                <div class="paso-linea"></div>
                <% }%>
            </div>
            <% }%>
        </div>

        <%-- INCLUIR EL JSP SEGÚN TIPO Y ESCENARIO --%>
        <% if ("DRAG_AND_DROP".equals(actividad.getTipo())) {
            if (idEscenario == 1 || idEscenario == 2) { %>
                <jsp:include page="/actividades/esc1-2-dnd.jsp"/>
            <% } else if (idEscenario == 3) { %>
                <jsp:include page="/actividades/esc3.jsp"/>
            <% } else if (idEscenario == 4) { %>
                <jsp:include page="/actividades/esc4.jsp"/>
            <% } else if (idEscenario == 5) { %>
                <jsp:include page="/actividades/esc5.jsp"/>
            <% } else if (idEscenario == 6) { %>
                <jsp:include page="/actividades/esc6.jsp"/>
            <% }
        } else if ("MATCH_DIPOLOS".equals(actividad.getTipo())) { %>
            <jsp:include page="/actividades/match-dipolos.jsp"/>
        <% } else if ("MATCH_PUENTES_H".equals(actividad.getTipo())) { %>
            <jsp:include page="/actividades/match-puentes.jsp"/>
        <% } else if ("SIMULACION_ESTADOS".equals(actividad.getTipo())) { %>
            <jsp:include page="/actividades/sim-estados.jsp"/>
        <% } else if ("IDENTIFICACION_PROPIEDAD".equals(actividad.getTipo())) { %>
            <jsp:include page="/actividades/identificacion.jsp"/>
        <% } else if ("SIMULACION_EBULLICION".equals(actividad.getTipo())) { %>
            <jsp:include page="/actividades/sim-ebullicion.jsp"/>
        <% } else { %>
            <div style="padding:32px; text-align:center;">Actividad no disponible aún.</div>
        <% } %>

    </div>

    <script>
        const btnT = document.getElementById('btnTema');
        function aplicarTema(esDia) { document.body.classList.toggle('dia', esDia); btnT.textContent = esDia ? '☀️ Día' : '🌙 Noche'; }
        function toggleTema() { const esDia = document.body.classList.contains('dia'); localStorage.setItem('chefMolecularTema', esDia ? 'noche' : 'dia'); aplicarTema(!esDia); }
        if (localStorage.getItem('chefMolecularTema') === 'dia') aplicarTema(true);
    </script>
</body>
</html>