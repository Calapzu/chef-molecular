<%-- 
    Document   : resultado
    Created on : 12/04/2026, 4:01:35 p. m.
    Author     : Usuario
    Modified   : Versión con temática de cocina molecular
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%
    int correctas = (int) request.getAttribute("correctas");
    int total = (int) request.getAttribute("total");
    int puntaje = (int) request.getAttribute("puntaje");
    int estrellas = (int) request.getAttribute("estrellas");
    int idEscenario = (int) request.getAttribute("idEscenario");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chef Molecular — Resultado del Quiz</title>
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
                position: relative;
                overflow-x: hidden;
            }

            /* Fondo con textura de cocina */
            body::before {
                content: '';
                position: fixed;
                inset: 0;
                background-image:
                    radial-gradient(ellipse at 20% 30%, rgba(200,122,44,0.05) 0%, transparent 50%),
                    repeating-linear-gradient(45deg, rgba(200,122,44,0.02) 0px, rgba(200,122,44,0.02) 2px, transparent 2px, transparent 8px);
                pointer-events: none;
                z-index: 0;
            }

            /* Veta lateral decorativa */
            body::after {
                content: '';
                position: fixed;
                left: 0;
                top: 0;
                width: 3px;
                height: 100%;
                background: linear-gradient(to bottom, transparent, #C87A2C 30%, #D4A438 50%, #C87A2C 70%, transparent);
                pointer-events: none;
                z-index: 1;
            }

            /* ═══ TARJETA DE RESULTADO (COCINA MOLECULAR) ═══ */
            .resultado-card {
                background: #110D06;
                border: 1px solid #2E2010;
                border-radius: 16px;
                padding: 48px 44px;
                width: 100%;
                max-width: 520px;
                position: relative;
                z-index: 2;
                backdrop-filter: blur(2px);
                transition: border-color 0.3s;
                text-align: center;
            }
            .resultado-card:hover {
                border-color: rgba(200,122,44,0.4);
            }

            /* Marco interior decorativo */
            .resultado-card::before {
                content: '';
                position: absolute;
                inset: 10px;
                border: 1px solid rgba(200,122,44,0.12);
                border-radius: 12px;
                pointer-events: none;
            }

            /* Encabezado */
            .resultado-header {
                margin-bottom: 28px;
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
                color: #D4A438;
                font-weight: 500;
                margin-bottom: 18px;
            }
            .resultado-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2rem;
                font-weight: 700;
                color: #F5ECD7;
                line-height: 1.1;
                margin-bottom: 6px;
            }
            .resultado-titulo span {
                color: #C87A2C;
                font-style: italic;
            }

            /* Estrellas obtenidas */
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
                background-position: center;
            }
            .estrella-on {
                background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%23D4A438"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>');
            }
            .estrella-off {
                background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="rgba(212,164,56,0.2)"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>');
            }

            /* Porcentaje */
            .puntaje {
                font-family: 'Playfair Display', serif;
                font-size: 3.5rem;
                font-weight: 700;
                color: #C87A2C;
                margin: 16px 0 8px;
                line-height: 1;
            }

            /* Estadísticas */
            .stats {
                background: rgba(7,21,37,0.6);
                border-radius: 12px;
                padding: 20px;
                margin: 24px 0;
                border: 1px solid #2E2010;
            }
            .stat-item {
                display: flex;
                justify-content: space-between;
                align-items: baseline;
                padding: 8px 0;
                border-bottom: 1px solid rgba(46,32,16,0.5);
            }
            .stat-item:last-child {
                border-bottom: none;
            }
            .stat-label {
                font-size: 13px;
                color: rgba(245,236,215,0.5);
                letter-spacing: 0.5px;
            }
            .stat-valor {
                font-weight: 700;
                font-size: 1.1rem;
                color: #D4A438;
            }

            /* Mensaje condicional */
            .mensaje-reprobado {
                background: rgba(200,60,30,0.12);
                border-left: 3px solid #C83A1E;
                padding: 14px 16px;
                border-radius: 8px;
                font-size: 13px;
                color: #E06A4A;
                margin: 20px 0;
                text-align: left;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .mensaje-reprobado::before {
                content: '🍳';
                font-size: 18px;
            }

            /* Botones */
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
                letter-spacing: 0.8px;
                transition: all 0.2s;
            }
            .btn-menu {
                background: transparent;
                border: 1px solid #2E2010;
                color: rgba(245,236,215,0.7);
            }
            .btn-menu:hover {
                border-color: #C87A2C;
                color: #C87A2C;
                background: rgba(200,122,44,0.05);
            }
            .btn-repetir {
                background: #C87A2C;
                color: #F5ECD7;
                border: none;
            }
            .btn-repetir:hover {
                background: #D98A3C;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(200,122,44,0.3);
            }

            @media (max-width: 520px) {
                .resultado-card {
                    padding: 32px 24px;
                }
                .puntaje {
                    font-size: 2.5rem;
                }
                .estrella-resultado {
                    width: 36px;
                    height: 36px;
                }
            }
        </style>
    </head>
    <body>

        <div class="resultado-card">
            <div class="resultado-header">
                <div class="resultado-badge">
                    <span>🍽️</span> Evaluación culinaria
                </div>
                <h1 class="resultado-titulo">Tu resultado<br><span>del quiz</span></h1>
            </div>

            <div class="estrellas-container">
                <div class="estrella-resultado <%= estrellas >= 1 ? "estrella-on" : "estrella-off"%>"></div>
                <div class="estrella-resultado <%= estrellas >= 2 ? "estrella-on" : "estrella-off"%>"></div>
                <div class="estrella-resultado <%= estrellas >= 3 ? "estrella-on" : "estrella-off"%>"></div>
            </div>

            <div class="puntaje"><%= puntaje%>%</div>

            <div class="stats">
                <div class="stat-item">
                    <span class="stat-label">✅ Respuestas correctas</span>
                    <span class="stat-valor"><%= correctas%> / <%= total%></span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">⭐ Estrellas obtenidas</span>
                    <span class="stat-valor"><%= estrellas%> de 3</span>
                </div>
            </div>

            <% if (estrellas == 0) { %>
            <div class="mensaje-reprobado">
                Necesitas mínimo 50% (al menos 3 estrellas) para completar este escenario. 
                Revísalo bien y vuelve a intentarlo. ¡La práctica hace al chef!
            </div>
            <% } else { %>
            <div style="margin: 16px 0; color: rgba(245,236,215,0.4); font-size: 12px; display: flex; align-items: center; justify-content: center; gap: 8px;">
                <span>👨‍🍳</span> ¡Excelente trabajo! Has demostrado tu conocimiento.
            </div>
            <% }%>

            <div class="buttons">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-menu">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                    Volver al menú
                </a>
                <a href="${pageContext.request.contextPath}/quiz?escenario=<%= idEscenario%>" class="btn btn-repetir">
                    🔁 Repetir quiz
                </a>
            </div>
        </div>

    </body>
</html>