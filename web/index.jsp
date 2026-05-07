<%-- 
    Document   : index
    Created on : 12/04/2026, 3:58:35 p. m.
    Author     : Usuario
    Modified   : Versión con temática de cocina molecular + toggle modo noche/día
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chef Molecular — Iniciar Sesión</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            /* ══ VARIABLES DE MODO ══ */
            :root {
                --body-bg: #1a1208;
                --izq-bg: #F7F3EC;
                --izq-titulo: #1C1208;
                --izq-subtitulo: #7A6A50;
                --izq-footer-txt: #9A8A70;
                --esc-nombre: #3A2C18;
                --esc-tema: #9A8A70;
                --esc-bg: rgba(255,255,255,0.6);
                --esc-border: rgba(200,185,155,0.4);
                --esc-bg-hover: rgba(255,255,255,0.9);
                --divisor-linea: #C8B89A;
                --der-bg: #110D06;
                --form-titulo: #F5ECD7;
                --form-sub: rgba(245,236,215,0.3);
                --campo-label: rgba(245,236,215,0.3);
                --campo-label-focus: rgba(200,122,44,0.7);
                --campo-input: #F5ECD7;
                --campo-border: #2E2010;
                --sep-linea: #2E2010;
                --sep-txt: rgba(245,236,215,0.15);
                --btn-reg-color: rgba(245,236,215,0.5);
                --btn-reg-border: #2E2010;
                --btn-reg-hover: #F5ECD7;
                --pie-color: rgba(245,236,215,0.1);
                --badge-bg: rgba(180,120,20,0.1);
                --badge-border: rgba(180,120,20,0.2);
                --badge-color: #8A6010;
                --error-bg: rgba(160,40,20,0.12);
            }

            /* ══ MODO DÍA ══ */
            body.modo-dia {
                --body-bg: #EDE8DF;
                --izq-bg: #FFFFFF;
                --izq-titulo: #1C1208;
                --izq-subtitulo: #6A5A40;
                --izq-footer-txt: #8A7A60;
                --esc-nombre: #2A1C08;
                --esc-tema: #8A7A60;
                --esc-bg: rgba(255,255,255,0.9);
                --esc-border: rgba(180,155,110,0.4);
                --esc-bg-hover: #FFFFFF;
                --divisor-linea: #B8A88A;
                --der-bg: #FDF8F0;
                --form-titulo: #1C1208;
                --form-sub: rgba(28,18,8,0.45);
                --campo-label: rgba(28,18,8,0.4);
                --campo-label-focus: #A06010;
                --campo-input: #1C1208;
                --campo-border: #C8B89A;
                --sep-linea: #C8B89A;
                --sep-txt: rgba(28,18,8,0.25);
                --btn-reg-color: rgba(28,18,8,0.5);
                --btn-reg-border: #C8B89A;
                --btn-reg-hover: #1C1208;
                --pie-color: rgba(28,18,8,0.2);
                --badge-bg: rgba(180,120,20,0.08);
                --badge-border: rgba(180,120,20,0.25);
                --badge-color: #7A5010;
                --error-bg: rgba(160,40,20,0.08);
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--body-bg);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 24px;
                transition: background 0.4s ease;
            }

            /* ══ BOTÓN TOGGLE MODO ══ */
            .btn-modo {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 100;
                width: 48px;
                height: 48px;
                border-radius: 50%;
                background: #C87A2C;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.3);
                transition: background 0.3s, transform 0.2s, box-shadow 0.3s;
                outline: none;
            }

            .btn-modo:hover {
                background: #D98A3C;
                transform: scale(1.1);
                box-shadow: 0 6px 20px rgba(200,122,44,0.5);
            }

            .btn-modo:active {
                transform: scale(0.95);
            }

            .btn-modo .icono-modo {
                transition: opacity 0.2s, transform 0.3s;
                display: inline-block;
            }

            .pagina {
                display: grid;
                grid-template-columns: 1fr 1fr;
                width: 100%;
                max-width: 960px;
                min-height: 580px;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 32px 80px rgba(0,0,0,0.5);
                transition: box-shadow 0.4s;
            }

            body.modo-dia .pagina {
                box-shadow: 0 32px 80px rgba(0,0,0,0.15);
            }

            /* ═══════════════════════
               PANEL IZQUIERDO
            ═══════════════════════ */
            .panel-izq {
                background: var(--izq-bg);
                position: relative;
                overflow: hidden;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                padding: 48px 44px;
                transition: background 0.4s;
            }

            .panel-izq::before {
                content: '';
                position: absolute;
                inset: 0;
                background-image:
                    url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%238A6010"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 4c1.1 0 2 .9 2 2s-.9 2-2 2-2-.9-2-2 .9-2 2-2zm0 13c-2.33 0-4.31-1.46-5.11-3.5h10.22c-.8 2.04-2.78 3.5-5.11 3.5z"/></svg>'),
                    linear-gradient(#D8D0C4 1px, transparent 1px),
                    linear-gradient(90deg, #D8D0C4 1px, transparent 1px);
                background-repeat: repeat, repeat, repeat;
                background-size: 28px 28px, 52px 52px, 52px 52px;
                opacity: 0.12;
                pointer-events: none;
            }

            .panel-izq::after {
                content: '';
                position: absolute;
                top: -60px;
                right: -60px;
                width: 280px;
                height: 280px;
                background: radial-gradient(circle, rgba(200,122,44,0.12) 0%, transparent 70%);
                pointer-events: none;
            }

            .izq-top {
                position: relative;
                z-index: 2;
            }

            .badge-univ {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: var(--badge-bg);
                border: 1px solid var(--badge-border);
                border-radius: 100px;
                padding: 5px 14px;
                font-size: 10px;
                letter-spacing: 1px;
                text-transform: uppercase;
                color: var(--badge-color);
                font-weight: 500;
                margin-bottom: 28px;
                transition: background 0.4s, border-color 0.4s, color 0.4s;
            }

            .badge-dot {
                width: 5px;
                height: 5px;
                border-radius: 50%;
                background: #C87A2C;
                animation: pulsar 2s ease-in-out infinite;
            }

            @keyframes pulsar {
                0%, 100% { opacity: 1; transform: scale(1); }
                50% { opacity: 0.4; transform: scale(0.7); }
            }

            .izq-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 3rem;
                font-weight: 700;
                color: var(--izq-titulo);
                line-height: 1.05;
                margin-bottom: 6px;
                transition: color 0.4s;
            }

            .izq-titulo span {
                color: #C87A2C;
                font-style: italic;
                display: block;
            }

            .izq-subtitulo {
                font-size: 13px;
                color: var(--izq-subtitulo);
                font-weight: 300;
                margin-bottom: 36px;
                letter-spacing: 0.3px;
                transition: color 0.4s;
            }

            .divisor-deco {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 28px;
            }

            .div-linea {
                height: 1px;
                background: var(--divisor-linea);
                flex: 1;
                transition: background 0.4s;
            }

            .div-rombo {
                width: 8px;
                height: 8px;
                background: #C87A2C;
                transform: rotate(45deg);
                border-radius: 1px;
            }

            .escenarios-lista {
                display: flex;
                flex-direction: column;
                gap: 9px;
            }

            .esc-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 9px 14px;
                background: var(--esc-bg);
                border: 1px solid var(--esc-border);
                border-radius: 8px;
                transition: background 0.2s, border-color 0.2s;
            }

            .esc-item:hover {
                background: var(--esc-bg-hover);
                border-color: rgba(200,122,44,0.3);
            }

            .esc-num { font-size: 14px; min-width: 28px; text-align: center; }

            .esc-nombre {
                font-size: 11.5px;
                color: var(--esc-nombre);
                font-weight: 400;
                flex: 1;
                transition: color 0.4s;
            }

            .esc-tema {
                font-size: 10px;
                color: var(--esc-tema);
                font-weight: 300;
                transition: color 0.4s;
            }

            .esc-lock {
                width: 8px;
                height: 8px;
                border: 1.5px solid #C8B89A;
                border-radius: 2px;
                position: relative;
                flex-shrink: 0;
            }

            .esc-lock::before {
                content: '';
                position: absolute;
                top: -5px;
                left: 50%;
                transform: translateX(-50%);
                width: 6px;
                height: 5px;
                border: 1.5px solid #C8B89A;
                border-bottom: none;
                border-radius: 3px 3px 0 0;
            }

            .esc-check {
                width: 14px;
                height: 14px;
                border-radius: 50%;
                background: rgba(200,122,44,0.1);
                border: 1.5px solid #C87A2C;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
            }

            .esc-check::after {
                content: '';
                width: 4px;
                height: 7px;
                border-right: 1.5px solid #C87A2C;
                border-bottom: 1.5px solid #C87A2C;
                transform: rotate(45deg) translate(-1px, -1px);
            }

            .izq-footer {
                position: relative;
                z-index: 2;
                display: flex;
                align-items: center;
                gap: 8px;
                margin-top: 24px;
            }

            .estrella-deco {
                width: 10px;
                height: 10px;
                background: #C87A2C;
                clip-path: polygon(50% 0%,61% 35%,98% 35%,68% 57%,79% 91%,50% 70%,21% 91%,32% 57%,2% 35%,39% 35%);
            }

            .izq-footer-txt {
                font-size: 10px;
                color: var(--izq-footer-txt);
                letter-spacing: 1px;
                transition: color 0.4s;
            }

            /* ════════════════════════
               PANEL DERECHO
            ════════════════════════ */
            .panel-der {
                background: var(--der-bg);
                display: flex;
                flex-direction: column;
                justify-content: center;
                padding: 52px 48px;
                position: relative;
                overflow: hidden;
                transition: background 0.4s;
            }

            .panel-der::after {
                content: '';
                position: absolute;
                top: 20%;
                right: 10%;
                width: 140px;
                height: 100px;
                background: radial-gradient(circle, rgba(255,240,200,0.12) 0%, transparent 70%);
                filter: blur(12px);
                pointer-events: none;
                animation: vapor 6s ease-in-out infinite;
                z-index: 0;
            }

            @keyframes vapor {
                0% { transform: translateY(0) scale(1); opacity: 0.2; }
                50% { transform: translateY(-20px) scale(1.3); opacity: 0.4; }
                100% { transform: translateY(0) scale(1); opacity: 0.2; }
            }

            .panel-der::before {
                content: '';
                position: absolute;
                bottom: -80px;
                left: -80px;
                width: 240px;
                height: 240px;
                background: radial-gradient(circle, rgba(200,122,44,0.08) 0%, transparent 70%);
                pointer-events: none;
            }

            .form-encabezado {
                margin-bottom: 40px;
                position: relative;
                z-index: 1;
            }

            .form-saludo {
                font-size: 10px;
                letter-spacing: 3px;
                text-transform: uppercase;
                color: #C87A2C;
                font-weight: 500;
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .form-saludo::before {
                content: '';
                width: 20px;
                height: 1px;
                background: #C87A2C;
            }

            .form-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2rem;
                color: var(--form-titulo);
                font-weight: 700;
                line-height: 1.2;
                margin-bottom: 6px;
                transition: color 0.4s;
            }

            .form-sub {
                font-size: 13px;
                color: var(--form-sub);
                font-weight: 300;
                transition: color 0.4s;
            }

            .nota-error {
                background: var(--error-bg);
                border-left: 2px solid #A02814;
                padding: 10px 14px;
                font-size: 12px;
                color: #D4604A;
                margin-bottom: 24px;
                border-radius: 0 4px 4px 0;
                display: none;
                position: relative;
                z-index: 1;
            }

            .nota-error.visible { display: block; }

            .campo {
                margin-bottom: 30px;
                position: relative;
                z-index: 1;
            }

            .campo label {
                display: block;
                font-size: 10px;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: var(--campo-label);
                font-weight: 500;
                margin-bottom: 10px;
                transition: color 0.3s;
            }

            .campo input {
                width: 100%;
                background: transparent;
                border: none;
                border-bottom: 1px solid var(--campo-border);
                padding: 8px 0 10px;
                color: var(--campo-input);
                font-size: 14px;
                font-family: 'DM Sans', sans-serif;
                font-weight: 300;
                outline: none;
                transition: color 0.4s, border-color 0.4s;
            }

            .campo input::placeholder { color: rgba(245,236,215,0.15); }

            body.modo-dia .campo input::placeholder { color: rgba(28,18,8,0.2); }

            .campo::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 0;
                height: 1px;
                background: #C87A2C;
                transition: width 0.4s ease;
            }

            .campo:focus-within label { color: var(--campo-label-focus); }

            .campo:focus-within::after { width: 100%; }

            .btn-entrar {
                width: 100%;
                padding: 15px;
                background: #C87A2C;
                color: #F5ECD7;
                border: none;
                border-radius: 4px;
                font-size: 11px;
                font-family: 'DM Sans', sans-serif;
                font-weight: 500;
                letter-spacing: 3px;
                text-transform: uppercase;
                cursor: pointer;
                transition: all 0.2s;
                margin-top: 4px;
                position: relative;
                overflow: hidden;
                z-index: 1;
            }

            .btn-entrar:hover {
                background: #D98A3C;
                box-shadow: 0 -4px 12px rgba(200,122,44,0.6), 0 4px 8px rgba(0,0,0,0.2);
            }

            .btn-entrar:active { transform: scale(0.99); }

            .btn-entrar::after {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 50%;
                height: 100%;
                background: rgba(255,200,100,0.08);
                transform: skewX(-15deg);
                transition: left 0.5s ease;
            }

            .btn-entrar:hover::after { left: 150%; }

            .btn-entrar:hover::before {
                content: '🔥';
                position: absolute;
                left: 12px;
                top: -20px;
                font-size: 18px;
                opacity: 0;
                animation: flame 0.8s infinite alternate;
                pointer-events: none;
            }

            @keyframes flame {
                from { transform: scale(0.8) translateY(0); opacity: 0.6; }
                to { transform: scale(1.2) translateY(-6px); opacity: 1; }
            }

            .sep {
                display: flex;
                align-items: center;
                gap: 14px;
                margin: 28px 0;
                position: relative;
                z-index: 1;
            }

            .sep-l {
                flex: 1;
                height: 1px;
                background: var(--sep-linea);
                transition: background 0.4s;
            }

            .sep-txt {
                font-size: 10px;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: var(--sep-txt);
                transition: color 0.4s;
            }

            .btn-registro {
                width: 100%;
                padding: 14px;
                background: transparent;
                color: var(--btn-reg-color);
                border: 1px solid var(--btn-reg-border);
                border-radius: 4px;
                font-size: 12px;
                font-family: 'DM Sans', sans-serif;
                font-weight: 300;
                letter-spacing: 0.5px;
                cursor: pointer;
                text-decoration: none;
                display: block;
                text-align: center;
                transition: border-color 0.25s, color 0.25s;
                position: relative;
                z-index: 1;
            }

            .btn-registro:hover {
                border-color: rgba(200,122,44,0.4);
                color: var(--btn-reg-hover);
            }

            .pie {
                margin-top: 36px;
                font-size: 10px;
                color: var(--pie-color);
                text-align: center;
                letter-spacing: 0.5px;
                position: relative;
                z-index: 1;
                transition: color 0.4s;
            }

            @media (max-width: 640px) {
                .pagina { grid-template-columns: 1fr; }
                .panel-izq { min-height: 280px; padding: 36px 28px; }
                .panel-der { padding: 40px 28px; }
                .izq-titulo { font-size: 2.2rem; }
                .btn-modo { top: 12px; right: 12px; }
            }
        </style>
    </head>
    <body>

        <!-- ══ BOTÓN MODO NOCHE / DÍA ══ -->
        <button class="btn-modo" id="btnModo" title="Cambiar modo" aria-label="Cambiar entre modo noche y modo día">
            <span class="icono-modo" id="iconoModo">🌙</span>
        </button>

        <div class="pagina">

            <!-- ══ PANEL IZQUIERDO ══ -->
            <div class="panel-izq">

                <div class="izq-top">

                    <div class="badge-univ">
                        <div class="badge-dot"></div>
                        🧑‍🍳 Laboratorio de Cocina Molecular · UniAmazonia
                    </div>

                    <div class="izq-titulo">
                        🍴 Chef
                        <span>Molecular 🔪</span>
                    </div>
                    <p class="izq-subtitulo">Alta cocina científica · 6 escenarios</p>

                    <div class="divisor-deco">
                        <div class="div-linea"></div>
                        <div class="div-rombo"></div>
                        <div class="div-linea"></div>
                    </div>

                    <div class="escenarios-lista">

                        <div class="esc-item">
                            <span class="esc-num">🧊</span>
                            <span class="esc-nombre">La Cocina Fría</span>
                            <span class="esc-tema">Dispersión de London</span>
                            <div class="esc-check"></div>
                        </div>

                        <div class="esc-item">
                            <span class="esc-num">🥄</span>
                            <span class="esc-nombre">La Sala de Salsas</span>
                            <span class="esc-tema">Dipolo-dipolo</span>
                            <div class="esc-lock"></div>
                        </div>

                        <div class="esc-item">
                            <span class="esc-num">🥚</span>
                            <span class="esc-nombre">Taller del Merengue</span>
                            <span class="esc-tema">Puentes de hidrógeno</span>
                            <div class="esc-lock"></div>
                        </div>

                        <div class="esc-item">
                            <span class="esc-num">🔥</span>
                            <span class="esc-nombre">El Horno y Congelador</span>
                            <span class="esc-tema">Estados de la materia</span>
                            <div class="esc-lock"></div>
                        </div>

                        <div class="esc-item">
                            <span class="esc-num">🍸</span>
                            <span class="esc-nombre">El Bar Molecular</span>
                            <span class="esc-tema">Propiedades de líquidos</span>
                            <div class="esc-lock"></div>
                        </div>

                        <div class="esc-item">
                            <span class="esc-num">⏲️</span>
                            <span class="esc-nombre">La Olla a Presión</span>
                            <span class="esc-tema">Presión de vapor</span>
                            <div class="esc-lock"></div>
                        </div>

                    </div>
                </div>

                <div class="izq-footer">
                    <div class="estrella-deco"></div>
                    <div class="estrella-deco"></div>
                    <div class="estrella-deco"></div>
                    <span class="izq-footer-txt">Ingeniería de Sistemas · 2026</span>
                </div>

            </div>

            <!-- ══ PANEL DERECHO (login) ══ -->
            <div class="panel-der">

                <div class="form-encabezado">
                    <div class="form-saludo">Bienvenido de vuelta</div>
                    <div class="form-titulo">Entra a tu<br>cocina</div>
                    <div class="form-sub">Continúa donde lo dejaste</div>
                </div>

                <%
                    String errorMsg = (String) request.getAttribute("error");
                    if (errorMsg != null) {
                        if (errorMsg.toLowerCase().contains("contraseña") || errorMsg.toLowerCase().contains("password")) {
                            errorMsg = "🔥 ¡Ups! Se te quemó la contraseña. Intenta de nuevo.";
                        } else if (errorMsg.toLowerCase().contains("usuario") || errorMsg.toLowerCase().contains("correo")) {
                            errorMsg = "🧂 No encontramos ese comensal. ¿Revisaste el correo?";
                        } else {
                            errorMsg = "🍳 Algo salió mal en la cocina. Verifica tus credenciales.";
                        }
                    }
                %>
                <% if (errorMsg != null) {%>
                <div class="nota-error visible"><%= errorMsg%></div>
                <% }%>

                <form action="${pageContext.request.contextPath}/login" method="post">

                    <div class="campo">
                        <label>Correo electrónico</label>
                        <input
                            type="email"
                            name="correo"
                            required
                            placeholder="tu@correo.com"
                            autocomplete="email"
                            >
                    </div>

                    <div class="campo">
                        <label>Contraseña</label>
                        <input
                            type="password"
                            name="password"
                            required
                            placeholder="el fuego que no se apaga"
                            autocomplete="current-password"
                            >
                    </div>

                    <button type="submit" class="btn-entrar">
                        Entrar a la cocina
                    </button>

                </form>

                <div class="sep">
                    <div class="sep-l"></div>
                    <span class="sep-txt">o</span>
                    <div class="sep-l"></div>
                </div>

                <a href="${pageContext.request.contextPath}/registro" class="btn-registro">
                    ¿Primera vez aquí? — Créate un perfil
                </a>

                <div class="pie">
                    🍽️ Gastronomía Molecular & Sistemas · UniAmazonia 🧪
                </div>

            </div>

        </div>

        <script>
            const btn = document.getElementById('btnModo');
            const icono = document.getElementById('iconoModo');
            const body = document.body;

            // Recordar preferencia del usuario
            const modoGuardado = localStorage.getItem('chefModo');
            if (modoGuardado === 'dia') {
                body.classList.add('modo-dia');
                icono.textContent = '☀️';
            }

            btn.addEventListener('click', function () {
                const esDia = body.classList.toggle('modo-dia');
                icono.textContent = esDia ? '☀️' : '🌙';
                localStorage.setItem('chefModo', esDia ? 'dia' : 'noche');
            });
        </script>

    </body>
</html>