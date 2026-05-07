<%-- 
    Document   : registro
    Created on : 12/04/2026, 3:58:57 p. m.
    Author     : Usuario
    Modified   : Versión con temática de cocina molecular + modo noche/día
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chef Molecular — Registro de Chef</title>
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
                --bg-card: #110D06;
                --border: #2E2010;
                --border-in: rgba(200,122,44,0.12);
                --text-ppal: #F5ECD7;
                --text-dim: rgba(245,236,215,0.3);
                --text-muted: rgba(245,236,215,0.25);
                --cobre: #C87A2C;
                --dorado: #D4A438;
                --input-bg: rgba(7,21,37,0.6);
                --input-border: #2E2010;
                --error-bg: rgba(200,60,30,0.12);
                --error-border: #C83A1E;
                --error-color: #E06A4A;
            }

            body.dia {
                --bg-base: #EDE8DF;
                --bg-card: #FFFFFF;
                --border: #D8CDB8;
                --border-in: rgba(155,85,21,0.12);
                --text-ppal: #1C1208;
                --text-dim: rgba(28,18,8,0.45);
                --text-muted: rgba(28,18,8,0.35);
                --cobre: #9B5515;
                --dorado: #8A6A00;
                --input-bg: #F5F0E8;
                --input-border: #D8CDB8;
                --error-bg: rgba(200,60,30,0.08);
                --error-border: #C83A1E;
                --error-color: #C83A1E;
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
                position: relative;
                overflow-x: hidden;
                transition: background 0.3s ease, color 0.2s ease;
            }

            /* Fondo con textura sutil de cocina */
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
                background: linear-gradient(to bottom, transparent, var(--cobre) 30%, var(--dorado) 50%, var(--cobre) 70%, transparent);
                pointer-events: none;
                z-index: 1;
            }

            /* ═══ BOTÓN DE MODO (esquina superior derecha de la tarjeta) ═══ */
            .btn-modo-container {
                position: absolute;
                top: 20px;
                right: 20px;
                z-index: 10;
            }
            .btn-modo {
                width: 38px;
                height: 38px;
                border-radius: 50%;
                background: var(--cobre);
                border: 1px solid rgba(245,236,215,0.2);
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                transition: all 0.3s ease;
                outline: none;
                box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            }
            .btn-modo:hover {
                background: #D98A3C;
                transform: scale(1.05);
                box-shadow: 0 4px 12px rgba(200,122,44,0.4);
            }
            body.dia .btn-modo {
                background: var(--cobre);
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            }
            body.dia .btn-modo:hover {
                background: #B86A20;
            }

            /* ═══ TARJETA DE REGISTRO (COCINA MOLECULAR) ═══ */
            .registro-card {
                background: var(--bg-card);
                border: 1px solid var(--border);
                border-radius: 16px;
                padding: 48px 44px;
                width: 100%;
                max-width: 460px;
                position: relative;
                z-index: 2;
                backdrop-filter: blur(2px);
                transition: all 0.3s ease;
            }
            .registro-card:hover {
                border-color: rgba(200,122,44,0.4);
            }

            /* Marco interior decorativo (como una carta de restaurante) */
            .registro-card::before {
                content: '';
                position: absolute;
                inset: 10px;
                border: 1px solid var(--border-in);
                border-radius: 12px;
                pointer-events: none;
                transition: border-color 0.3s ease;
            }

            /* Encabezado */
            .registro-header {
                text-align: center;
                margin-bottom: 32px;
            }
            .registro-badge {
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
                margin-bottom: 18px;
            }
            .registro-titulo {
                font-family: 'Playfair Display', serif;
                font-size: 2rem;
                font-weight: 700;
                color: var(--text-ppal);
                line-height: 1.1;
                margin-bottom: 6px;
                transition: color 0.2s ease;
            }
            .registro-titulo span {
                color: var(--cobre);
                font-style: italic;
            }
            .registro-sub {
                font-size: 13px;
                color: var(--text-dim);
                font-weight: 300;
                transition: color 0.2s ease;
            }

            /* Mensaje de error */
            .error-msg {
                background: var(--error-bg);
                border-left: 3px solid var(--error-border);
                padding: 12px 16px;
                border-radius: 6px;
                font-size: 12px;
                color: var(--error-color);
                margin-bottom: 24px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .error-msg::before {
                content: '🔥';
                font-size: 14px;
            }

            /* Campos del formulario */
            .campo {
                margin-bottom: 20px;
            }
            .campo label {
                display: block;
                font-size: 11px;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: var(--text-muted);
                font-weight: 500;
                margin-bottom: 8px;
                transition: color 0.2s ease;
            }
            .campo input {
                width: 100%;
                background: var(--input-bg);
                border: 1px solid var(--input-border);
                border-radius: 8px;
                padding: 12px 16px;
                font-family: 'DM Sans', sans-serif;
                font-size: 14px;
                color: var(--text-ppal);
                font-weight: 300;
                outline: none;
                transition: all 0.2s;
            }
            .campo input:focus {
                border-color: var(--cobre);
                background: rgba(7,21,37,0.9);
                box-shadow: 0 0 0 2px rgba(200,122,44,0.2);
            }
            body.dia .campo input:focus {
                background: #FFFFFF;
            }
            .campo input::placeholder {
                color: var(--text-muted);
                opacity: 0.5;
            }

            /* Botón de registro (con efecto llama) */
            .btn-registro {
                width: 100%;
                background: var(--cobre);
                color: #F5ECD7;
                border: none;
                border-radius: 8px;
                padding: 14px 20px;
                font-family: 'DM Sans', sans-serif;
                font-size: 12px;
                font-weight: 600;
                letter-spacing: 3px;
                text-transform: uppercase;
                cursor: pointer;
                transition: all 0.25s;
                margin-top: 8px;
                position: relative;
                overflow: hidden;
            }
            .btn-registro:hover {
                background: #D98A3C;
                box-shadow: 0 -4px 12px rgba(200,122,44,0.4), 0 4px 8px rgba(0,0,0,0.2);
                transform: translateY(-1px);
            }
            body.dia .btn-registro:hover {
                background: #B86A20;
            }
            .btn-registro:active {
                transform: translateY(1px);
            }
            .btn-registro::before {
                content: '🔥';
                position: absolute;
                left: 20px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 16px;
                opacity: 0;
                transition: opacity 0.2s;
            }
            .btn-registro:hover::before {
                opacity: 1;
            }

            /* Separador y enlace a login */
            .registro-footer {
                margin-top: 28px;
                text-align: center;
                font-size: 12px;
                color: var(--text-muted);
                transition: color 0.2s ease;
            }
            .registro-footer a {
                color: var(--dorado);
                text-decoration: none;
                border-bottom: 1px dotted rgba(212,164,56,0.4);
                transition: color 0.2s;
            }
            .registro-footer a:hover {
                color: var(--cobre);
                border-bottom-color: var(--cobre);
            }
        </style>
    </head>
    <body>

        <div class="registro-card">
            <!-- ══ BOTÓN DE MODO NOCHE/DÍA ══ -->
            <div class="btn-modo-container">
                <button class="btn-modo" id="btnModo" title="Cambiar modo de color">
                    <span id="iconoModo">🌙</span>
                </button>
            </div>

            <div class="registro-header">
                <div class="registro-badge">
                    <span>🍳</span> Nuevo chef molecular
                </div>
                <h1 class="registro-titulo">Crear tu<br><span>cuenta culinaria</span></h1>
                <p class="registro-sub">Únete a la comunidad y comienza tu formación</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
            <div class="error-msg">${error}</div>
            <% }%>

            <form action="${pageContext.request.contextPath}/registro" method="post">
                <div class="campo">
                    <label>👨‍🍳 Nombre completo</label>
                    <input type="text" name="nombre" required placeholder="Tu nombre como chef" autocomplete="name">
                </div>
                <div class="campo">
                    <label>📧 Correo electrónico</label>
                    <input type="email" name="correo" required placeholder="tu@correo.com" autocomplete="email">
                </div>
                <div class="campo">
                    <label>🔒 Contraseña (mínimo 6 caracteres)</label>
                    <input type="password" name="password" required minlength="6" placeholder="••••••" autocomplete="new-password">
                </div>
                <button type="submit" class="btn-registro">Crear cuenta</button>
            </form>

            <div class="registro-footer">
                ¿Ya tienes cuenta? <a href="${pageContext.request.contextPath}/index.jsp">Inicia sesión aquí</a>
            </div>
        </div>

        <script>
            // ══ TOGGLE MODO NOCHE/DÍA ══
            const CLAVE = 'chefMolecularTema';
            const btn = document.getElementById('btnModo');
            const icono = document.getElementById('iconoModo');
            const body = document.body;

            // Cargar preferencia guardada
            const modoGuardado = localStorage.getItem(CLAVE);
            if (modoGuardado === 'dia') {
                body.classList.add('dia');
                icono.textContent = '☀️';
            }

            btn.addEventListener('click', function () {
                const esDia = body.classList.toggle('dia');
                icono.textContent = esDia ? '☀️' : '🌙';
                localStorage.setItem(CLAVE, esDia ? 'dia' : 'noche');
            });
        </script>

    </body>
</html>