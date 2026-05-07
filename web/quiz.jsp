<%-- 
    Document   : quiz
    Created on : 12/04/2026, 4:01:24 p. m.
    Author     : Usuario
    Modified   : Versión con temática de cocina molecular
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.Pregunta, java.util.List" %>
<%
    List<Pregunta> preguntas = (List<Pregunta>) request.getAttribute("preguntas");
    int idEscenario = (int) request.getAttribute("idEscenario");
    // Para mostrar nombre del escenario (opcional, se puede pasar desde el controlador)
    String nombreEscenario = (String) request.getAttribute("nombreEscenario");
    if (nombreEscenario == null)
        nombreEscenario = "Escenario " + idEscenario;
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chef Molecular — Quiz | <%= nombreEscenario%></title>
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
            }

            /* ═══ NAVBAR COCINA MOLECULAR ═══ */
            .navbar {
                background: #110D06;
                border-bottom: 1px solid #2E2010;
                padding: 0 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 64px;
                position: sticky;
                top: 0;
                z-index: 100;
            }
            .navbar-marca {
                display: flex;
                align-items: center;
                gap: 14px;
            }
            .marca-icono {
                width: 34px;
                height: 34px;
                background: #C87A2C;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .marca-icono svg {
                width: 18px;
                height: 18px;
                fill: #F5ECD7;
            }
            .marca-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 1.1rem;
                color: #F5ECD7;
                font-weight: 700;
                letter-spacing: 0.5px;
            }
            .marca-nombre span {
                color: #C87A2C;
                font-style: italic;
            }
            .navbar-nav {
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .nav-link {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 7px 14px;
                border-radius: 6px;
                text-decoration: none;
                font-size: 12px;
                font-weight: 400;
                color: rgba(245,236,215,0.5);
                letter-spacing: 0.3px;
                border: 1px solid transparent;
                transition: all 0.2s;
            }
            .nav-link:hover {
                color: #F5ECD7;
                background: rgba(255,255,255,0.04);
                border-color: #2E2010;
            }
            .nav-link.activo {
                color: #D4A438;
                border-color: rgba(212,164,56,0.25);
                background: rgba(212,164,56,0.05);
            }
            .nav-link svg {
                width: 14px;
                height: 14px;
                fill: currentColor;
                flex-shrink: 0;
            }
            .nav-salir {
                color: rgba(200,122,44,0.7);
                border-color: rgba(200,122,44,0.2);
            }
            .nav-salir:hover {
                color: #C87A2C;
                background: rgba(200,122,44,0.06);
                border-color: rgba(200,122,44,0.4);
            }

            /* ═══ CONTENEDOR PRINCIPAL ═══ */
            .contenedor {
                max-width: 800px;
                margin: 0 auto;
                padding: 48px 24px 80px;
            }

            /* ═══ ENCABEZADO DEL QUIZ ═══ */
            .quiz-header {
                text-align: center;
                margin-bottom: 40px;
            }
            .quiz-badge {
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
                margin-bottom: 20px;
            }
            .quiz-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2rem;
                font-weight: 700;
                color: #F5ECD7;
                line-height: 1.1;
                margin-bottom: 8px;
            }
            .quiz-titulo span {
                color: #C87A2C;
                font-style: italic;
            }
            .quiz-desc {
                font-size: 13px;
                color: rgba(245,236,215,0.3);
                font-weight: 300;
                max-width: 500px;
                margin: 0 auto;
            }

            /* ═══ TARJETA DE PREGUNTA ═══ */
            .pregunta-card {
                background: #110D06;
                border: 1px solid #2E2010;
                border-radius: 12px;
                padding: 24px;
                margin-bottom: 24px;
                transition: border-color 0.2s;
            }
            .pregunta-card:hover {
                border-color: rgba(200,122,44,0.4);
            }
            .pregunta-num {
                font-size: 10px;
                letter-spacing: 3px;
                text-transform: uppercase;
                color: #C87A2C;
                font-weight: 500;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .pregunta-num::before {
                content: '';
                width: 20px;
                height: 1px;
                background: #C87A2C;
            }
            .pregunta-enunciado {
                font-family: 'Playfair Display', serif;
                font-size: 1.1rem;
                font-weight: 500;
                color: #F5ECD7;
                line-height: 1.4;
                margin-bottom: 20px;
            }
            .opciones {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .opcion-label {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 10px 16px;
                background: rgba(7,21,37,0.6);
                border: 1px solid #2E2010;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.2s;
            }
            .opcion-label:hover {
                background: rgba(200,122,44,0.05);
                border-color: rgba(200,122,44,0.3);
            }
            input[type="radio"] {
                appearance: none;
                width: 16px;
                height: 16px;
                border: 2px solid rgba(245,236,215,0.3);
                border-radius: 50%;
                margin: 0;
                position: relative;
                cursor: pointer;
                transition: all 0.2s;
                flex-shrink: 0;
            }
            input[type="radio"]:checked {
                border-color: #C87A2C;
                background: #C87A2C;
                box-shadow: inset 0 0 0 3px #110D06;
            }
            .opcion-texto {
                font-size: 14px;
                color: rgba(245,236,215,0.7);
                line-height: 1.4;
            }

            /* ═══ BOTÓN DE ENVÍO (CON EFECTO LLAMA) ═══ */
            .btn-enviar {
                display: block;
                width: 100%;
                background: #C87A2C;
                color: #F5ECD7;
                border: none;
                border-radius: 8px;
                padding: 16px 24px;
                font-family: 'DM Sans', sans-serif;
                font-size: 13px;
                font-weight: 600;
                letter-spacing: 3px;
                text-transform: uppercase;
                cursor: pointer;
                transition: all 0.25s;
                margin-top: 20px;
                position: relative;
                overflow: hidden;
            }
            .btn-enviar:hover {
                background: #D98A3C;
                box-shadow: 0 -4px 12px rgba(200,122,44,0.4), 0 4px 8px rgba(0,0,0,0.2);
                transform: translateY(-1px);
            }
            .btn-enviar:active {
                transform: translateY(1px);
            }
            .btn-enviar::before {
                content: '🔥';
                position: absolute;
                left: 20px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 16px;
                opacity: 0;
                transition: opacity 0.2s;
            }
            .btn-enviar:hover::before {
                opacity: 1;
            }

            /* ═══ PIE DE PÁGINA ═══ */
            .quiz-footer {
                text-align: center;
                margin-top: 32px;
                font-size: 10px;
                color: rgba(245,236,215,0.15);
                letter-spacing: 1px;
            }

            @media (max-width: 640px) {
                .navbar {
                    padding: 0 16px;
                }
                .contenedor {
                    padding: 32px 16px;
                }
                .quiz-titulo {
                    font-size: 1.5rem;
                }
                .pregunta-card {
                    padding: 18px;
                }
                .opcion-label {
                    padding: 8px 12px;
                }
            }
        </style>
    </head>
    <body>

        <!-- ══ NAVBAR COCINA MOLECULAR ══ -->
        <nav class="navbar">
            <div class="navbar-marca">
                <div class="marca-icono">
                    <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 4c1.1 0 2 .9 2 2s-.9 2-2 2-2-.9-2-2 .9-2 2-2zm0 13c-2.33 0-4.31-1.46-5.11-3.5h10.22c-.8 2.04-2.78 3.5-5.11 3.5z"/></svg>
                </div>
                <span class="marca-nombre">Chef <span>Molecular</span></span>
            </div>
            <div class="navbar-nav">
                <a href="${pageContext.request.contextPath}/menu" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Menú
                </a>
                <a href="${pageContext.request.contextPath}/perfil" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M12 12c2.7 0 4.8-2.1 4.8-4.8S14.7 2.4 12 2.4 7.2 4.5 7.2 7.2 9.3 12 12 12zm0 2.4c-3.2 0-9.6 1.6-9.6 4.8v2.4h19.2v-2.4c0-3.2-6.4-4.8-9.6-4.8z"/></svg>
                    Perfil
                </a>
                <a href="${pageContext.request.contextPath}/libroRecetas" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 14H7v-2h10v2zm0-4H7v-2h10v2zm0-4H7V6h10v2z"/></svg>
                    Recetas
                </a>
                <a href="${pageContext.request.contextPath}/ranking" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M7 21H3V9h4v12zm7 0h-4V3h4v18zm7 0h-4v-9h4v9z"/></svg>
                    Ranking
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-salir">
                    <svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5-5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    Salir
                </a>
            </div>
        </nav>

        <!-- ══ CONTENIDO DEL QUIZ ══ -->
        <div class="contenedor">
            <div class="quiz-header">
                <div class="quiz-badge">
                    <span>🍽️</span> Evaluación culinaria
                </div>
                <h1 class="quiz-titulo">Pon a prueba tu<br><span>técnica molecular</span></h1>
                <p class="quiz-desc">Responde correctamente al menos 3 preguntas para dominar este escenario y desbloquear nuevas recetas.</p>
            </div>

            <form action="${pageContext.request.contextPath}/quiz" method="post">
                <input type="hidden" name="idEscenario" value="<%= idEscenario%>">

                <%
                    int num = 1;
                    for (Pregunta p : preguntas) {
                %>
                <div class="pregunta-card">
                    <div class="pregunta-num">Pregunta <%= num++%> de <%= preguntas.size()%></div>
                    <div class="pregunta-enunciado"><%= p.getEnunciado()%></div>
                    <div class="opciones">
                        <label class="opcion-label">
                            <input type="radio" name="pregunta_<%= p.getIdPregunta()%>" value="1" required>
                            <span class="opcion-texto">A) <%= p.getOpcionA()%></span>
                        </label>
                        <label class="opcion-label">
                            <input type="radio" name="pregunta_<%= p.getIdPregunta()%>" value="2">
                            <span class="opcion-texto">B) <%= p.getOpcionB()%></span>
                        </label>
                        <label class="opcion-label">
                            <input type="radio" name="pregunta_<%= p.getIdPregunta()%>" value="3">
                            <span class="opcion-texto">C) <%= p.getOpcionC()%></span>
                        </label>
                        <label class="opcion-label">
                            <input type="radio" name="pregunta_<%= p.getIdPregunta()%>" value="4">
                            <span class="opcion-texto">D) <%= p.getOpcionD()%></span>
                        </label>
                    </div>
                </div>
                <% }%>

                <button type="submit" class="btn-enviar">Enviar respuestas ➜</button>
            </form>

            <div class="quiz-footer">
                Chef Molecular · Universidad de la Amazonia
            </div>
        </div>

    </body>
</html>