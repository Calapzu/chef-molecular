<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.dao.ProgresoDAO, com.chefmolecular.dao.ActividadDAO, com.chefmolecular.modelo.Estudiante" %>
<%
    Estudiante est = (Estudiante) session.getAttribute("estudiante");
    
    // Obtener parámetro escenario
    String escenarioParam = request.getParameter("escenario");
    if (escenarioParam == null || escenarioParam.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/menu");
        return;
    }
    
    int idEscenario = Integer.parseInt(escenarioParam);
    
    ProgresoDAO progresoDAO = new ProgresoDAO();
    ActividadDAO actividadDAO = new ActividadDAO();
    
    int estrellas = 0;
    int puntajePromedio = 0;
    boolean completado = false;
    
    try {
        var progreso = progresoDAO.buscar(est.getIdEstudiante(), idEscenario);
        if (progreso != null) {
            estrellas = progreso.getEstrellas();
        }
        puntajePromedio = actividadDAO.calcularPuntajeTotalEscenario(est.getIdEstudiante(), idEscenario);
        completado = actividadDAO.todasActividadesCompletadas(est.getIdEstudiante(), idEscenario);
    } catch (Exception e) {
        e.printStackTrace();
    }
    
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
    <title>Chef Molecular — Resultado | <%= nombreEscenario %></title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg-base: #0C0702;
            --bg-card: #110D06;
            --border: #2E2010;
            --text-ppal: #F5ECD7;
            --text-dim: rgba(245,236,215,0.3);
            --cobre: #C87A2C;
            --dorado: #D4A438;
        }

        body.dia {
            --bg-base: #EDE8DF;
            --bg-card: #FFFFFF;
            --border: #D8CDB8;
            --text-ppal: #1C1208;
            --text-dim: rgba(28,18,8,0.45);
            --cobre: #9B5515;
            --dorado: #8A6A00;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg-base);
            color: var(--text-ppal);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            transition: background 0.3s, color 0.3s;
        }

        .resultado-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 48px 44px;
            width: 100%;
            max-width: 520px;
            text-align: center;
            position: relative;
        }

        .resultado-card::before {
            content: '';
            position: absolute;
            inset: 10px;
            border: 1px solid rgba(200,122,44,0.12);
            border-radius: 12px;
            pointer-events: none;
        }

        .resultado-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(200,122,44,0.1);
            border: 1px solid rgba(200,122,44,0.2);
            border-radius: 100px;
            padding: 5px 14px;
            font-size: 10px;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--dorado);
            margin-bottom: 18px;
        }

        .resultado-titulo {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .resultado-titulo span { color: var(--cobre); font-style: italic; }

        .estrellas-container {
            margin: 20px 0;
            display: flex;
            justify-content: center;
            gap: 12px;
        }

        .estrella-resultado {
            width: 48px;
            height: 48px;
            background-size: contain;
            background-repeat: no-repeat;
        }

        .estrella-on {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%23D4A438"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>');
        }

        .estrella-off {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="rgba(212,164,56,0.2)"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>');
        }

        .puntaje {
            font-family: 'Playfair Display', serif;
            font-size: 3.5rem;
            font-weight: 700;
            color: var(--cobre);
            margin: 16px 0 8px;
        }

        .stats {
            background: rgba(7,21,37,0.6);
            border-radius: 12px;
            padding: 20px;
            margin: 24px 0;
        }

        .stat-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid var(--border);
        }

        .stat-item:last-child { border-bottom: none; }

        .stat-label { font-size: 13px; color: var(--text-dim); }
        .stat-valor { font-weight: 700; color: var(--dorado); }

        .mensaje-exito {
            background: rgba(76,175,80,0.1);
            border-left: 3px solid #4CAF50;
            padding: 14px 16px;
            border-radius: 8px;
            font-size: 13px;
            color: #4CAF50;
            margin: 20px 0;
        }

        .mensaje-error {
            background: rgba(244,67,54,0.1);
            border-left: 3px solid #f44336;
            padding: 14px 16px;
            border-radius: 8px;
            font-size: 13px;
            color: #f44336;
            margin: 20px 0;
        }

        .buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-top: 24px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-menu {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--text-dim);
        }

        .btn-menu:hover {
            border-color: var(--cobre);
            color: var(--cobre);
        }

        .btn-repetir {
            background: var(--cobre);
            color: white;
            border: none;
        }

        .btn-repetir:hover {
            background: #D98A3C;
            transform: translateY(-1px);
        }

        @media (max-width: 520px) {
            .resultado-card { padding: 32px 24px; }
            .puntaje { font-size: 2.5rem; }
            .estrella-resultado { width: 36px; height: 36px; }
        }
    </style>
</head>
<body>

<div class="resultado-card">
    <div class="resultado-badge">
        <span>🍽️</span> Resultado final
    </div>
    <h1 class="resultado-titulo">Tu desempeño en<br><span><%= nombreEscenario %></span></h1>

    <div class="estrellas-container">
        <div class="estrella-resultado <%= estrellas >= 1 ? "estrella-on" : "estrella-off" %>"></div>
        <div class="estrella-resultado <%= estrellas >= 2 ? "estrella-on" : "estrella-off" %>"></div>
        <div class="estrella-resultado <%= estrellas >= 3 ? "estrella-on" : "estrella-off" %>"></div>
    </div>

    <div class="puntaje"><%= puntajePromedio %>%</div>

    <div class="stats">
        <div class="stat-item">
            <span class="stat-label">🎯 Puntaje promedio</span>
            <span class="stat-valor"><%= puntajePromedio %>%</span>
        </div>
        <div class="stat-item">
            <span class="stat-label">⭐ Estrellas obtenidas</span>
            <span class="stat-valor"><%= estrellas %> de 3</span>
        </div>
        <div class="stat-item">
            <span class="stat-label">📊 Estado</span>
            <span class="stat-valor"><%= completado ? "✅ Completado" : "🔄 En progreso" %></span>
        </div>
    </div>

    <% if (estrellas == 0) { %>
        <div class="mensaje-error">
            ❌ Necesitas mínimo 50% de puntaje para completar este escenario. ¡Vuelve a intentarlo!
        </div>
    <% } else if (estrellas == 3) { %>
        <div class="mensaje-exito">
            🏆 ¡PERFECTO! Obtuviste el máximo puntaje. ¡Eres un verdadero Chef Molecular!
        </div>
    <% } else { %>
        <div class="mensaje-exito">
            👨‍🍳 ¡Buen trabajo! Sigue así para convertirte en un experto de la cocina molecular.
        </div>
    <% } %>

    <div class="buttons">
        <a href="${pageContext.request.contextPath}/menu" class="btn btn-menu">
            ← Volver al menú
        </a>
        <a href="${pageContext.request.contextPath}/actividad?escenario=<%= idEscenario %>" class="btn btn-repetir">
            🔁 Practicar de nuevo
        </a>
    </div>
</div>

<script>
    // MODO DÍA/NOCHE
    const CLAVE = 'chefMolecularTema';
    const body = document.body;
    
    function aplicarTema(esDia) {
        if (esDia) body.classList.add('dia');
        else body.classList.remove('dia');
    }
    
    const guardado = localStorage.getItem(CLAVE);
    if (guardado === 'dia') aplicarTema(true);
</script>
</body>
</html>