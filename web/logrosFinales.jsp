<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.Insignia, java.util.List" %>
<%
    int estrellas = (int) session.getAttribute("estrellasFinales");
    String rango = (String) session.getAttribute("rangoFinal");
    List<Insignia> insignias = (List<Insignia>) session.getAttribute("insigniasTotales");
    int posicion = (int) session.getAttribute("posicionRanking");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chef Molecular — ¡Juego Completado!</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'DM Sans', sans-serif;
                background: #0C0702;
                color: #F5ECD7;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 24px;
            }
            .logros-card {
                background: #110D06;
                border: 1px solid #2E2010;
                border-radius: 16px;
                padding: 48px 44px;
                width: 100%;
                max-width: 600px;
                text-align: center;
                position: relative;
            }
            .logros-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 8px;
            }
            .logros-titulo span {
                color: #C87A2C;
                font-style: italic;
            }
            .logros-badge {
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
                color: #D4A438;
                margin-bottom: 24px;
            }
            .stats-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
                margin: 24px 0;
            }
            .stat-box {
                background: rgba(200,122,44,0.05);
                border: 1px solid rgba(200,122,44,0.2);
                border-radius: 12px;
                padding: 16px;
            }
            .stat-valor {
                font-family: 'Playfair Display', serif;
                font-size: 2rem;
                font-weight: 700;
                color: #C87A2C;
            }
            .stat-label {
                font-size: 0.7rem;
                text-transform: uppercase;
                letter-spacing: 2px;
                color: rgba(245,236,215,0.5);
                margin-top: 4px;
            }
            .insignias-lista {
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
                justify-content: center;
                margin: 24px 0;
            }
            .insignia-item {
                background: rgba(212,164,56,0.1);
                border: 1px solid #D4A438;
                border-radius: 8px;
                padding: 8px 16px;
                font-size: 0.8rem;
                color: #D4A438;
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .btn-menu {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: #C87A2C;
                color: #F5ECD7;
                padding: 12px 28px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                margin-top: 24px;
                transition: background 0.2s;
            }
            .btn-menu:hover {
                background: #D98A3C;
            }
        </style>
    </head>
    <body>
        <div class="logros-card">
            <div class="logros-badge">🏆 ¡Juego completado!</div>
            <h1 class="logros-titulo">¡Felicidades, <span>Chef Molecular!</span></h1>
            <p style="color: rgba(245,236,215,0.5);">Has completado todos los escenarios.</p>

            <div class="stats-grid">
                <div class="stat-box">
                    <div class="stat-valor"><%= estrellas%> ★</div>
                    <div class="stat-label">Estrellas finales</div>
                </div>
                <div class="stat-box">
                    <div class="stat-valor"><%= rango%></div>
                    <div class="stat-label">Rango alcanzado</div>
                </div>
                <div class="stat-box">
                    <div class="stat-valor">#<%= posicion%></div>
                    <div class="stat-label">Posición en ranking</div>
                </div>
                <div class="stat-box">
                    <div class="stat-valor"><%= insignias != null ? insignias.size() : 0%></div>
                    <div class="stat-label">Insignias obtenidas</div>
                </div>
            </div>

            <% if (insignias != null && !insignias.isEmpty()) { %>
            <div class="insignias-lista">
                <% for (Insignia i : insignias) {%>
                <div class="insignia-item">🏅 <%= i.getNombre()%></div>
                <% } %>
            </div>
            <% }%>

            <a href="${pageContext.request.contextPath}/menu" class="btn-menu">Volver al menú</a>
        </div>
    </body>
</html>