<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.Estudiante, java.util.List" %>
<%
    List<Estudiante> top10 = (List<Estudiante>) request.getAttribute("top10");
    int posicion = (int) request.getAttribute("posicion");
    int idActual = (int) request.getAttribute("idActual");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chef Molecular — Ranking de Chefs</title>
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
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--bg-base);
                color: var(--text-ppal);
                min-height: 100vh;
                transition: background 0.3s ease, color 0.2s ease;
            }

            /* ═══ NAVBAR COCINA MOLECULAR ═══ */
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

            /* ═══ CONTENEDOR PRINCIPAL ═══ */
            .contenedor {
                max-width: 900px;
                margin: 0 auto;
                padding: 48px 24px 80px;
            }

            /* ═══ ENCABEZADO DEL RANKING ═══ */
            .ranking-header {
                text-align: center;
                margin-bottom: 40px;
            }
            .ranking-badge {
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
                font-weight: 500;
                margin-bottom: 20px;
            }
            .ranking-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2rem;
                font-weight: 700;
                color: var(--text-ppal);
                line-height: 1.1;
                margin-bottom: 8px;
                transition: color 0.2s ease;
            }
            .ranking-titulo span {
                color: var(--cobre);
                font-style: italic;
            }
            .ranking-desc {
                font-size: 13px;
                color: var(--text-dim);
                font-weight: 300;
                max-width: 500px;
                margin: 0 auto;
            }

            /* ═══ TARJETA DE POSICIÓN PERSONAL ═══ */
            .mi-posicion {
                background: var(--bg-panel);
                border: 1px solid var(--cobre);
                border-radius: 12px;
                padding: 20px 24px;
                margin-bottom: 32px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 16px;
                transition: background 0.3s ease, border-color 0.3s ease;
            }
            .mi-posicion-info {
                display: flex;
                align-items: baseline;
                gap: 12px;
                flex-wrap: wrap;
            }
            .mi-posicion-label {
                font-size: 12px;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: var(--text-muted);
            }
            .mi-posicion-num {
                font-family: 'Playfair Display', serif;
                font-size: 2rem;
                font-weight: 700;
                color: var(--cobre);
                line-height: 1;
            }
            .mi-posicion-texto {
                font-size: 13px;
                color: var(--text-dim);
            }
            .mi-insignia {
                display: flex;
                align-items: center;
                gap: 8px;
                background: rgba(200,122,44,0.1);
                padding: 8px 16px;
                border-radius: 40px;
                font-size: 12px;
                color: var(--dorado);
            }

            /* ═══ TABLA DE RANKING (ESTILO MENÚ) ═══ */
            .tabla-ranking {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 32px;
            }
            .tabla-ranking th {
                text-align: left;
                padding: 16px 12px;
                font-size: 10px;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: var(--text-muted);
                font-weight: 500;
                border-bottom: 1px solid var(--border);
            }
            .tabla-ranking td {
                padding: 14px 12px;
                border-bottom: 1px solid var(--border-in);
                font-size: 14px;
                transition: border-color 0.3s ease;
            }
            .tabla-ranking tr:hover td {
                background: rgba(200,122,44,0.03);
            }
            .tabla-ranking .yo td {
                background: rgba(200,122,44,0.08);
                border-left: 2px solid var(--cobre);
            }
            .col-pos {
                width: 70px;
                font-weight: 500;
            }
            .medalla {
                font-size: 1.3rem;
                display: inline-block;
                width: 36px;
            }
            .col-nombre {
                font-weight: 500;
            }
            .col-rango {
                font-size: 11px;
                color: var(--text-dim);
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .col-estrellas {
                font-weight: 700;
                color: var(--dorado);
                text-align: right;
            }
            .estrella-icono {
                display: inline-block;
                width: 12px;
                height: 12px;
                background: var(--dorado);
                clip-path: polygon(50% 0%,61% 35%,98% 35%,68% 57%,79% 91%,50% 70%,21% 91%,32% 57%,2% 35%,39% 35%);
                margin-right: 4px;
            }

            /* ═══ BOTÓN VOLVER ═══ */
            .btn-volver {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: transparent;
                border: 1px solid var(--border);
                color: var(--text-dim);
                padding: 10px 24px;
                border-radius: 8px;
                text-decoration: none;
                font-size: 13px;
                font-weight: 500;
                transition: all 0.2s;
            }
            .btn-volver:hover {
                border-color: var(--cobre);
                color: var(--cobre);
                background: rgba(200,122,44,0.05);
            }

            @media (max-width: 640px) {
                .navbar {
                    padding: 0 16px;
                }
                .contenedor {
                    padding: 32px 16px;
                }
                .ranking-titulo {
                    font-size: 1.5rem;
                }
                .mi-posicion {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .tabla-ranking th, .tabla-ranking td {
                    padding: 10px 8px;
                    font-size: 12px;
                }
                .col-rango {
                    display: none;
                }
                .medalla {
                    width: 28px;
                    font-size: 1.1rem;
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
                <a href="${pageContext.request.contextPath}/ranking" class="nav-link activo">
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
        <div class="contenedor">

            <div class="ranking-header">
                <div class="ranking-badge">
                    <span>🏆</span> Tabla de honor culinaria
                </div>
                <h1 class="ranking-titulo">Ranking de<br><span>Chefs Moleculares</span></h1>
                <p class="ranking-desc">Los chefs con más estrellas Michelín en nuestra comunidad</p>
            </div>

            <!-- Tu posición -->
            <div class="mi-posicion">
                <div class="mi-posicion-info">
                    <span class="mi-posicion-label">Tu posición actual</span>
                    <span class="mi-posicion-num">#<%= posicion%></span>
                    <span class="mi-posicion-texto">en el ranking general</span>
                </div>
                <div class="mi-insignia">
                    <span>👨‍🍳</span> Sigue cocinando para subir puestos
                </div>
            </div>

            <!-- Tabla Top 10 -->
            <table class="tabla-ranking">
                <thead>
                    <tr>
                        <th class="col-pos">#</th>
                        <th>Chef</th>
                        <th class="col-rango">Rango</th>
                        <th class="col-estrellas">⭐ Estrellas</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String[] medallas = {"🥇", "🥈", "🥉"};
                        for (int i = 0; i < top10.size(); i++) {
                            Estudiante e = top10.get(i);
                            boolean esYo = e.getIdEstudiante() == idActual;
                            String med = i < 3 ? medallas[i] : String.valueOf(i + 1);
                            String medDisplay = i < 3 ? med : "";
                    %>
                    <tr class="<%= esYo ? "yo" : ""%>">
                        <td class="col-pos">
                            <span class="medalla"><%= medDisplay%></span>
                            <% if (i >= 3) {%><span style="margin-left: 8px;"><%= med%></span><% }%>
                        </td>
                        <td class="col-nombre">
                            <%= e.getNombreCompleto()%>
                            <% if (esYo) { %> <span style="color:var(--cobre); font-size:0.7rem; margin-left:6px;">← Tú</span><% }%>
                        </td>
                        <td class="col-rango"><%= e.getRango().replace("_", " ")%></td>
                        <td class="col-estrellas">
                            <span class="estrella-icono"></span>
                            <%= e.getTotalEstrellas()%>
                        </td>
                    </tr>
                    <% }%>
                </tbody>
            </table>

            <a href="${pageContext.request.contextPath}/menu" class="btn-volver">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Volver al menú
            </a>

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
                if (guardado === 'dia')
                    aplicarTema(true);
            })();
        </script>

    </body>
</html>