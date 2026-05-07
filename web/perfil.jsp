<%-- 
    Document   : perfil
    Created on : 12/04/2026, 3:59:18 p. m.
    Author     : Usuario
    Modified   : Versión con temática de cocina molecular + modo noche/día
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.Estudiante, com.chefmolecular.modelo.Insignia, com.chefmolecular.modelo.Receta, com.chefmolecular.modelo.ProgresoEscenario, java.util.List" %>
<%
    Estudiante est = (Estudiante) session.getAttribute("estudiante");
    List<Insignia> insignias = (List<Insignia>) request.getAttribute("insignias");
    List<Receta> recetasDesbloqueadas = (List<Receta>) request.getAttribute("recetasDesbloqueadas");
    List<ProgresoEscenario> progresos = (List<ProgresoEscenario>) request.getAttribute("progresos");
    int totalEstrellas = est != null ? est.getTotalEstrellas() : 0;
    int escenariosCompletados = 0;
    if (progresos != null)
        for (ProgresoEscenario p : progresos)
            if (p.isCompletado())
                escenariosCompletados++;
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chef Molecular — Mi Perfil Culinario</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            /* ══ VARIABLES DE MODO ══ */
            :root {
                --bg-base: #0C0702;
                --bg-panel: #110D06;
                --border: #2E2010;
                --border-in: #1E1508;
                --text-ppal: #F5ECD7;
                --text-dim: rgba(245,236,215,0.3);
                --text-muted: rgba(245,236,215,0.2);
                --text-nav: rgba(245,236,215,0.5);
                --cobre: #C87A2C;
                --dorado: #D4A438;
                --card-num: rgba(200,122,44,0.12);
            }

            body.dia {
                --bg-base: #F2EBD9;
                --bg-panel: #FBF6ED;
                --border: #D5C4A1;
                --border-in: #E8DCBF;
                --text-ppal: #1E1208;
                --text-dim: rgba(30,18,8,0.45);
                --text-muted: rgba(30,18,8,0.35);
                --text-nav: rgba(30,18,8,0.55);
                --cobre: #9B5515;
                --dorado: #8A6A00;
                --card-num: rgba(155,85,21,0.10);
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--bg-base);
                color: var(--text-ppal);
                min-height: 100vh;
                transition: background 0.3s ease, color 0.2s ease;
            }

            /* ═══ NAVBAR (unificada con el resto) ═══ */
            .navbar {
                background: var(--bg-panel);
                border-bottom: 1px solid var(--border);
                padding: 0 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 64px;
                position: sticky;
                top: 0;
                z-index: 100;
                transition: background 0.3s ease, border-color 0.3s ease;
            }
            .navbar-marca {
                display: flex;
                align-items: center;
                gap: 14px;
            }
            .marca-icono {
                width: 34px;
                height: 34px;
                background: var(--cobre);
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
                color: var(--text-ppal);
                font-weight: 700;
                letter-spacing: 0.5px;
                transition: color 0.2s ease;
            }
            .marca-nombre span {
                color: var(--cobre);
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
                color: var(--text-nav);
                letter-spacing: 0.3px;
                border: 1px solid transparent;
                transition: all 0.2s;
            }
            .nav-link:hover {
                color: var(--text-ppal);
                background: rgba(200,122,44,0.06);
                border-color: var(--border);
            }
            .nav-link.activo {
                color: var(--dorado);
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
                color: var(--cobre);
                background: rgba(200,122,44,0.06);
                border-color: rgba(200,122,44,0.4);
            }

            /* ═══ BOTÓN TEMA (integrado en navbar) ═══ */
            .btn-tema {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 7px 14px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 400;
                font-family: 'DM Sans', sans-serif;
                letter-spacing: 0.3px;
                color: var(--text-nav);
                background: none;
                border: 1px solid var(--border);
                cursor: pointer;
                transition: all 0.2s;
            }
            .btn-tema svg {
                width: 14px;
                height: 14px;
                fill: currentColor;
                flex-shrink: 0;
            }
            .btn-tema:hover {
                color: var(--dorado);
                border-color: rgba(212,164,56,0.35);
                background: rgba(212,164,56,0.06);
            }

            /* ═══ WRAPPER PRINCIPAL ═══ */
            .pagina {
                max-width: 1100px;
                margin: 0 auto;
                padding: 48px 24px 80px;
            }

            /* ═══ TARJETA DE PERFIL (CHEF) ═══ */
            .perfil-card {
                background: var(--bg-panel);
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 32px;
                margin-bottom: 48px;
                display: flex;
                align-items: center;
                gap: 32px;
                position: relative;
                overflow: hidden;
                transition: background 0.3s ease, border-color 0.3s ease;
            }
            /* Fondo decorativo con utensilios muy sutiles */
            .perfil-card::before {
                content: '';
                position: absolute;
                inset: 0;
                background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="rgba(200,122,44,0.03)"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 4c1.1 0 2 .9 2 2s-.9 2-2 2-2-.9-2-2 .9-2 2-2zm0 13c-2.33 0-4.31-1.46-5.11-3.5h10.22c-.8 2.04-2.78 3.5-5.11 3.5z"/></svg>');
                background-repeat: repeat;
                background-size: 28px;
                opacity: 0.3;
                pointer-events: none;
            }
            .avatar {
                width: 100px;
                height: 100px;
                background: var(--cobre);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 3rem;
                flex-shrink: 0;
                box-shadow: 0 0 0 4px rgba(200,122,44,0.2);
                transition: background 0.3s ease;
            }
            .perfil-info {
                position: relative;
                z-index: 1;
                flex: 1;
            }
            .perfil-nombre {
                font-family: 'Playfair Display', serif;
                font-size: 2rem;
                font-weight: 700;
                color: var(--text-ppal);
                margin-bottom: 4px;
                transition: color 0.2s ease;
            }
            .perfil-rango {
                display: inline-block;
                background: rgba(200,122,44,0.12);
                border: 1px solid rgba(200,122,44,0.3);
                border-radius: 100px;
                padding: 4px 12px;
                font-size: 0.7rem;
                letter-spacing: 1.5px;
                text-transform: uppercase;
                color: var(--dorado);
                margin-bottom: 20px;
            }
            .stats-grid {
                display: flex;
                gap: 32px;
                flex-wrap: wrap;
            }
            .stat {
                text-align: center;
            }
            .stat-valor {
                font-family: 'Playfair Display', serif;
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--cobre);
                line-height: 1;
                transition: color 0.2s ease;
            }
            .stat-label {
                font-size: 0.7rem;
                text-transform: uppercase;
                letter-spacing: 2px;
                color: var(--text-dim);
                margin-top: 4px;
                transition: color 0.2s ease;
            }

            /* ═══ SECCIÓN ESTILO MENÚ ═══ */
            .seccion {
                margin-bottom: 48px;
            }
            .seccion-head {
                display: flex;
                align-items: center;
                gap: 16px;
                margin-bottom: 24px;
            }
            .seccion-icono {
                font-size: 1.3rem;
            }
            .seccion-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1.2rem;
                font-weight: 700;
                color: var(--text-ppal);
                transition: color 0.2s ease;
            }
            .seccion-linea {
                flex: 1;
                height: 1px;
                background: var(--border);
                transition: background 0.3s ease;
            }

            /* Grillas */
            .grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                gap: 16px;
            }
            .card {
                background: var(--bg-panel);
                border: 1px solid var(--border);
                border-radius: 8px;
                padding: 18px;
                transition: all 0.2s;
            }
            .card:hover {
                border-color: rgba(200,122,44,0.4);
                transform: translateY(-2px);
            }
            .card-icono {
                font-size: 1.6rem;
                margin-bottom: 10px;
            }
            .card-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 1rem;
                font-weight: 700;
                margin-bottom: 6px;
                color: var(--text-ppal);
            }
            .card-desc {
                font-size: 0.75rem;
                color: var(--text-dim);
                line-height: 1.4;
            }
            .card-bloqueada {
                opacity: 0.5;
                filter: grayscale(0.2);
            }
            .card-bloqueada:hover {
                transform: none;
                border-color: var(--border);
            }

            /* Progreso de escenario con estrellas */
            .progreso-estrellas {
                display: flex;
                gap: 4px;
                margin: 10px 0 6px;
            }
            .estrella {
                width: 12px;
                height: 12px;
                clip-path: polygon(50% 0%,61% 35%,98% 35%,68% 57%,79% 91%,50% 70%,21% 91%,32% 57%,2% 35%,39% 35%);
            }
            .estrella.on  {
                background: var(--dorado);
            }
            .estrella.off {
                background: rgba(212,164,56,0.2);
            }
            .estado {
                font-size: 0.7rem;
                display: inline-block;
                padding: 3px 8px;
                border-radius: 20px;
                background: rgba(255,255,255,0.05);
            }
            .estado.completado {
                color: #4ade80;
                background: rgba(74,222,128,0.1);
            }
            .estado.disponible {
                color: var(--cobre);
                background: rgba(200,122,44,0.1);
            }
            .estado.bloqueado {
                color: var(--text-muted);
            }
            .intentos {
                font-size: 0.65rem;
                color: var(--text-muted);
                margin-top: 6px;
            }

            /* Mensaje vacío */
            .mensaje-vacio {
                text-align: center;
                padding: 32px;
                background: var(--bg-panel);
                border: 1px solid var(--border);
                border-radius: 8px;
                color: var(--text-dim);
                font-style: italic;
                transition: background 0.3s ease, border-color 0.3s ease;
            }

            @media (max-width: 640px) {
                .navbar {
                    padding: 0 16px;
                }
                .perfil-card {
                    flex-direction: column;
                    text-align: center;
                }
                .stats-grid {
                    justify-content: center;
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
                <a href="${pageContext.request.contextPath}/perfil" class="nav-link activo">
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

                <!-- ══ BOTÓN MODO DÍA / NOCHE ══ -->
                <button class="btn-tema" id="btnTema" onclick="toggleTema()" title="Cambiar modo de color">
                    <svg viewBox="0 0 24 24" id="iconoTema" width="14" height="14">
                        <path id="iconoPath" d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z"/>
                    </svg>
                    <span id="textoTema">Día</span>
                </button>

                <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-salir">
                    <svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5-5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    Salir
                </a>
            </div>
        </nav>

        <!-- ══ CONTENIDO PRINCIPAL ══ -->
        <div class="pagina">

            <!-- Tarjeta de perfil del chef -->
            <div class="perfil-card">
                <div class="avatar">👨‍🍳</div>
                <div class="perfil-info">
                    <div class="perfil-nombre"><%= est != null ? est.getNombreCompleto() : "Chef Invitado"%></div>
                    <div class="perfil-rango">🏅 <%= est != null && est.getRango() != null ? est.getRango().replace("_", " ") : "APRENDIZ"%></div>
                    <div class="stats-grid">
                        <div class="stat">
                            <div class="stat-valor"><%= totalEstrellas%></div>
                            <div class="stat-label">Estrellas Michelín</div>
                        </div>
                        <div class="stat">
                            <div class="stat-valor"><%= escenariosCompletados%></div>
                            <div class="stat-label">Escenarios completados</div>
                        </div>
                        <div class="stat">
                            <div class="stat-valor"><%= recetasDesbloqueadas != null ? recetasDesbloqueadas.size() : 0%></div>
                            <div class="stat-label">Recetas dominadas</div>
                        </div>
                        <div class="stat">
                            <div class="stat-valor"><%= insignias != null ? insignias.stream().filter(i -> i.isObtenida()).count() : 0%></div>
                            <div class="stat-label">Insignias</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sección: Progreso por escenario -->
            <div class="seccion">
                <div class="seccion-head">
                    <span class="seccion-icono">🍽️</span>
                    <span class="seccion-titulo">Progreso en las cocinas</span>
                    <div class="seccion-linea"></div>
                </div>
                <div class="grid">
                    <% if (progresos != null)
              for (ProgresoEscenario p : progresos) {%>
                    <div class="card">
                        <div class="card-titulo">Escenario <%= p.getOrdenEscenario()%> — <%= p.getNombreEscenario()%></div>
                        <div class="progreso-estrellas">
                            <div class="estrella <%= p.getEstrellas() >= 1 ? "on" : "off"%>"></div>
                            <div class="estrella <%= p.getEstrellas() >= 2 ? "on" : "off"%>"></div>
                            <div class="estrella <%= p.getEstrellas() >= 3 ? "on" : "off"%>"></div>
                        </div>
                        <div class="estado 
                             <%= !p.isDesbloqueado() ? "bloqueado" : p.isCompletado() ? "completado" : "disponible"%>">
                            <%= !p.isDesbloqueado() ? "🔒 Bloqueado" : p.isCompletado() ? "✅ Completado" : "🔥 Disponible"%>
                        </div>
                        <div class="intentos">Intentos: <%= p.getIntentos()%></div>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Sección: Insignias culinarias -->
            <div class="seccion">
                <div class="seccion-head">
                    <span class="seccion-icono">🏅</span>
                    <span class="seccion-titulo">Insignias del chef</span>
                    <div class="seccion-linea"></div>
                </div>
                <div class="grid">
                    <% if (insignias != null)
              for (Insignia ins : insignias) {%>
                    <div class="card <%= !ins.isObtenida() ? "card-bloqueada" : ""%>">
                        <div class="card-icono"><%= ins.isObtenida() ? "🏅" : "🔒"%></div>
                        <div class="card-titulo"><%= ins.getNombre()%></div>
                        <div class="card-desc"><%= ins.getDescripcion()%></div>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Sección: Recetas desbloqueadas (menú personal) -->
            <div class="seccion">
                <div class="seccion-head">
                    <span class="seccion-icono">📖</span>
                    <span class="seccion-titulo">Recetas en tu recetario</span>
                    <div class="seccion-linea"></div>
                </div>
                <% if (recetasDesbloqueadas == null || recetasDesbloqueadas.isEmpty()) { %>
                <div class="mensaje-vacio">
                    🧂 Aún no has desbloqueado ninguna receta. Completa escenarios para descubrir nuevas preparaciones.
                </div>
                <% } else { %>
                <div class="grid">
                    <% for (Receta r : recetasDesbloqueadas) {%>
                    <div class="card">
                        <div class="card-icono">🍲</div>
                        <div class="card-titulo"><%= r.getNombre()%></div>
                        <div class="card-desc"><%= r.getDescripcion()%></div>
                    </div>
                    <% } %>
                </div>
                <% }%>
            </div>

        </div>

        <!-- ══ SCRIPT MODO DÍA / NOCHE ══ -->
        <script>
            const CLAVE = 'chefMolecularTema';
            const btnT = document.getElementById('btnTema');
            const icoP = document.getElementById('iconoPath');
            const textoT = document.getElementById('textoTema');

            /* Icono luna — se muestra cuando el modo DÍA está activo (clic → volver a noche) */
            const LUNA = 'M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9c0-.46-.04-.92-.1-1.36-' +
                '.98 1.37-2.58 2.26-4.4 2.26-2.98 0-5.4-2.42-5.4-5.4 0-1.81.89-3.42 2.26-4.4-.44-.06-.9-.1-1.36-.1z';

            /* Icono sol — se muestra cuando el modo NOCHE está activo (clic → ir a día) */
            const SOL = 'M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5z' +
                'M2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1z' +
                'm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1z' +
                'M11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1z' +
                'm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1z' +
                'M5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58z' +
                'm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06z' +
                'm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z' +
                'M7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z';

            function aplicarTema(esDia) {
                if (esDia) {
                    document.body.classList.add('dia');
                    icoP.setAttribute('d', LUNA);
                    textoT.textContent = 'Noche';
                } else {
                    document.body.classList.remove('dia');
                    icoP.setAttribute('d', SOL);
                    textoT.textContent = 'Día';
                }
            }

            function toggleTema() {
                const ahora = document.body.classList.contains('dia');
                const nuevo = !ahora;
                localStorage.setItem(CLAVE, nuevo ? 'dia' : 'noche');
                aplicarTema(nuevo);
            }

            /* Cargar preferencia guardada al iniciar la página */
            (function () {
                const guardado = localStorage.getItem(CLAVE);
                if (guardado === 'dia') aplicarTema(true);
            })();
        </script>

    </body>
</html>