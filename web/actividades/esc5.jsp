<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.ElementoArrastrable, com.chefmolecular.modelo.CategoriaActividad, java.util.List" %>
<%
    List<ElementoArrastrable> elementos = (List<ElementoArrastrable>) request.getAttribute("elementos");
    List<CategoriaActividad> categorias = (List<CategoriaActividad>) request.getAttribute("categorias");
    int actividadIdx = (int) request.getAttribute("actividadIdx");
    int totalActividades = (int) request.getAttribute("totalActividades");
    int idEscenario = (int) request.getAttribute("idEscenario");
    com.chefmolecular.modelo.ActividadInteractiva actividad = (com.chefmolecular.modelo.ActividadInteractiva) request.getAttribute("actividad");
%>
<style>
    /* ===== ESTILOS BASE ===== */
    .bar-card { background: linear-gradient(135deg, #0d0d1a, #1a0d2e); border: 2px solid #4a1a7a; border-radius: 20px; padding: 32px; margin-bottom: 24px; }
    .bar-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: #e0aaff; margin-bottom: 8px; }
    .bar-desc { color: rgba(224,170,255,0.6); font-size: 13px; margin-bottom: 24px; }

    /* Barra de progreso */
    .progreso-wrapper { margin-bottom: 20px; }
    .progreso-texto { font-size: 13px; color: rgba(224,170,255,0.7); margin-bottom: 6px; display: flex; justify-content: space-between; }
    .progreso-texto span { font-weight: 600; color: #00f5d4; }
    .progreso-barra-bg { background: rgba(123,47,255,0.2); border-radius: 99px; height: 8px; overflow: hidden; }
    .progreso-barra-fill { height: 100%; background: linear-gradient(90deg, #7b2fff, #00f5d4); border-radius: 99px; width: 0%; transition: width 0.4s ease; }

    /* Elementos tipo "copa" */
    .bar-elementos { display: flex; flex-wrap: wrap; gap: 12px; justify-content: center; margin: 20px 0; }
    .copa-elemento { background: linear-gradient(135deg, #2d1a4a, #1a2d4a); border: 2px solid #7b2fff; border-radius: 12px; padding: 16px 20px; cursor: pointer; font-size: 14px; color: #e0aaff; transition: all 0.3s; text-align: center; min-width: 120px; user-select: none; }
    .copa-elemento:hover { border-color: #00f5d4; color: #00f5d4; transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,245,212,0.2); }
    .copa-elemento:focus-visible { outline: 2px solid #00f5d4; outline-offset: 2px; }
    .copa-elemento.seleccionado { border-color: #00f5d4; background: linear-gradient(135deg, #1a3a3a, #2a1a4a); color: #00f5d4; box-shadow: 0 0 15px rgba(0,245,212,0.3); }
    .copa-elemento.asignado { border-color: #4caf50; background: linear-gradient(135deg, #1a2e1a, #1a2e1a); color: #4caf50; pointer-events: none; cursor: default; }
    .copa-elemento.shake { animation: shake 0.35s ease; }
    @keyframes shake { 0%,100% { transform: translateX(0); } 20% { transform: translateX(-5px); } 40% { transform: translateX(5px); } 60% { transform: translateX(-3px); } 80% { transform: translateX(3px); } }

    /* Zonas de destino */
    .bar-zonas { display: flex; gap: 16px; flex-wrap: wrap; justify-content: center; margin-top: 24px; }
    .zona-bar { flex: 1; min-width: 140px; border-radius: 12px; padding: 16px; min-height: 110px; border: 2px dashed #4a1a7a; background: rgba(74,26,122,0.1); text-align: center; transition: all 0.2s; cursor: pointer; }
    .zona-bar h4 { color: #7b2fff; font-size: 13px; margin-bottom: 10px; }
    .zona-bar:hover { border-color: #00f5d4; background: rgba(0,245,212,0.05); }
    .zona-bar:focus-visible { outline: 2px solid #00f5d4; outline-offset: 2px; }
    .zona-bar.activa { border-color: #00f5d4; background: rgba(0,245,212,0.08); transform: scale(1.02); }
    .zona-bar.drop-ok { animation: pulseOk 0.4s ease; border-color: #4caf50; background: rgba(76,175,80,0.1); }
    .zona-bar.drop-error { animation: pulseError 0.35s ease; border-color: #e53935; background: rgba(229,57,53,0.1); }
    @keyframes pulseOk { 0% { box-shadow: 0 0 0 0 rgba(76,175,80,0.4); } 70% { box-shadow: 0 0 0 8px rgba(76,175,80,0); } 100% { box-shadow: none; } }
    @keyframes pulseError { 0% { box-shadow: 0 0 0 0 rgba(229,57,53,0.4); } 70% { box-shadow: 0 0 0 8px rgba(229,57,53,0); } 100% { box-shadow: none; } }

    /* Elementos asignados dentro de zonas */
    .elem-asignado-bar { padding: 5px 10px; border-radius: 20px; font-size: 11px; margin: 3px; display: inline-block; background: rgba(0,245,212,0.15); color: #00f5d4; border: 1px solid #00f5d4; animation: fadeInUp 0.25s ease; }
    @keyframes fadeInUp { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }

    /* Botones de acción alineados */
    .acciones-bar { display: flex; justify-content: flex-end; gap: 16px; margin-top: 28px; flex-wrap: wrap; }
    .btn-bar, .btn-reiniciar { padding: 12px 28px; border-radius: 50px; font-weight: 600; cursor: pointer; transition: all 0.2s; font-size: 14px; border: none; font-family: 'DM Sans', sans-serif; }
    .btn-bar { background: linear-gradient(135deg, #7b2fff, #00f5d4); color: white; box-shadow: 0 2px 8px rgba(123,47,255,0.3); }
    .btn-bar:hover:not(:disabled) { opacity: 0.9; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(123,47,255,0.4); }
    .btn-bar:disabled { opacity: 0.3; cursor: not-allowed; transform: none; }
    .btn-reiniciar { background: transparent; border: 1px solid #7b2fff; color: #e0aaff; }
    .btn-reiniciar:hover { border-color: #00f5d4; background: rgba(0,245,212,0.05); color: #00f5d4; }

    /* Feedback */
    .feedback-bar { margin-top: 16px; padding: 12px 16px; border-radius: 8px; font-size: 13px; display: none; }
    .feedback-bar.success { background: rgba(0,245,212,0.1); border-left: 4px solid #00f5d4; color: #00f5d4; display: block; }
    .feedback-bar.error { background: rgba(255,50,50,0.1); border-left: 4px solid #ff3232; color: #ff3232; display: block; }

    /* Responsive */
    @media (max-width: 600px) {
        .bar-card { padding: 20px; }
        .copa-elemento { padding: 12px 16px; min-width: 100px; }
        .bar-zonas { flex-direction: column; }
        .acciones-bar { justify-content: stretch; }
        .acciones-bar button { flex: 1; text-align: center; }
    }

    /* Accesibilidad */
    .sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); border: 0; }
</style>

<div class="bar-card">
    <h2 class="bar-titulo">🍹 Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="bar-desc">Selecciona un elemento y luego haz clic en la categoría donde pertenece.</p>

    <!-- Barra de progreso -->
    <div class="progreso-wrapper">
        <div class="progreso-texto">
            <span id="progresoLabel">0 de <%= elementos.size() %> asignados</span>
            <span id="progresoPorc">0%</span>
        </div>
        <div class="progreso-barra-bg">
            <div class="progreso-barra-fill" id="progresoBarra"></div>
        </div>
    </div>

    <div class="bar-elementos" id="barElementos">
        <% for (ElementoArrastrable e : elementos) { %>
            <div class="copa-elemento" id="barElem_<%= e.getIdElemento() %>"
                 data-id="<%= e.getIdElemento() %>"
                 data-nombre="<%= e.getNombre() %>"
                 data-categoria-correcta="<%= e.getCategoriaCorrecta() %>"
                 role="button"
                 tabindex="0"
                 aria-label="Elemento: <%= e.getNombre() %>">
                🧪 <%= e.getNombre() %>
            </div>
        <% } %>
    </div>

    <div class="bar-zonas">
        <% for (CategoriaActividad cat : categorias) { %>
            <div class="zona-bar" id="zonaBar_<%= cat.getIdCategoria() %>"
                 data-categoria="<%= cat.getNombreCategoria() %>"
                 role="button"
                 tabindex="0"
                 aria-label="Categoría: <%= cat.getNombreCategoria() %>">
                <h4>🏷️ <%= cat.getNombreCategoria() %></h4>
                <div id="elemsZonaBar_<%= cat.getIdCategoria() %>" class="contenedor-asignados"></div>
            </div>
        <% } %>
    </div>

    <div class="acciones-bar">
        <button class="btn-reiniciar" id="btnReiniciarBar" aria-label="Reiniciar actividad">🔄 Reiniciar</button>
        <button class="btn-bar" id="btnEnviarBar" disabled aria-label="Enviar respuestas">✅ Servir respuestas</button>
    </div>
    <div class="feedback-bar" id="feedbackBar" role="status"></div>

    <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario %>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad() %>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx %>">
        <input type="hidden" name="respuestas" id="respuestasJsonDnD">
    </form>
</div>

<script>
    let asignacionesBar = {};
    let elementoSeleccionadoBar = null;
    let totalElementosBar = <%= elementos != null ? elementos.size() : 0 %>;
    let feedbackTimeout = null;
    let enviando = false;

    // ----- Funciones auxiliares -----
    function mostrarFeedbackBar(mensaje, tipo) {
        const fb = document.getElementById('feedbackBar');
        if (!fb) return;
        if (feedbackTimeout) clearTimeout(feedbackTimeout);
        fb.textContent = mensaje;
        fb.className = 'feedback-bar ' + tipo;
        feedbackTimeout = setTimeout(() => { fb.className = 'feedback-bar'; }, 3000);
    }

    function actualizarProgreso() {
        const asignados = Object.keys(asignacionesBar).length;
        const pct = Math.round((asignados / totalElementosBar) * 100);
        document.getElementById('progresoLabel').textContent = asignados + ' de ' + totalElementosBar + ' asignados';
        document.getElementById('progresoPorc').textContent = pct + '%';
        document.getElementById('progresoBarra').style.width = pct + '%';
        const btnEnviar = document.getElementById('btnEnviarBar');
        if (btnEnviar && !enviando) btnEnviar.disabled = (asignados !== totalElementosBar);
    }

    // Añadir elemento asignado a zona (sin innerHTML)
    function agregarElementoZona(zonaId, nombre) {
        const contenedor = document.getElementById('elemsZonaBar_' + zonaId);
        if (!contenedor) return;
        const span = document.createElement('span');
        span.className = 'elem-asignado-bar';
        span.textContent = nombre;
        contenedor.appendChild(span);
    }

    // Limpiar todas las zonas visualmente
    function limpiarZonasVisuales() {
        document.querySelectorAll('.contenedor-asignados').forEach(cont => {
            while (cont.firstChild) cont.removeChild(cont.firstChild);
        });
    }

    // Efecto flash en zona
    function flashZona(zona, tipo) {
        zona.classList.remove('drop-ok', 'drop-error');
        void zona.offsetWidth;
        zona.classList.add(tipo === 'ok' ? 'drop-ok' : 'drop-error');
        setTimeout(() => zona.classList.remove('drop-ok', 'drop-error'), 500);
    }

    // ----- Seleccionar elemento -----
    function seleccionarElementoBar(elem) {
        if (elem.classList.contains('asignado')) {
            mostrarFeedbackBar('Este elemento ya está asignado.', 'error');
            return;
        }
        // Si hay otro seleccionado, lo deseleccionamos
        if (elementoSeleccionadoBar && elementoSeleccionadoBar !== elem) {
            elementoSeleccionadoBar.classList.remove('seleccionado');
        }
        // Toggle selección
        if (elementoSeleccionadoBar === elem) {
            // Deseleccionar
            elem.classList.remove('seleccionado');
            elementoSeleccionadoBar = null;
            document.querySelectorAll('.zona-bar').forEach(z => z.classList.remove('activa'));
        } else {
            // Seleccionar nuevo
            elem.classList.add('seleccionado');
            elementoSeleccionadoBar = elem;
            document.querySelectorAll('.zona-bar').forEach(z => z.classList.add('activa'));
            // Anuncio para lectores de pantalla
            const anuncio = document.createElement('div');
            anuncio.className = 'sr-only';
            anuncio.textContent = 'Elemento seleccionado: ' + elem.dataset.nombre + '. Selecciona una categoría.';
            document.body.appendChild(anuncio);
            setTimeout(() => anuncio.remove(), 2000);
        }
    }

    // ----- Asignar a zona -----
    function asignarAZonaBar(zona) {
        if (!elementoSeleccionadoBar) {
            mostrarFeedbackBar('Primero selecciona un elemento.', 'error');
            return;
        }
        const elem = elementoSeleccionadoBar;
        const idElemento = elem.dataset.id;
        const nombreElemento = elem.dataset.nombre;
        const categoriaCorrecta = elem.dataset.categoriaCorrecta;
        const categoriaDestino = zona.dataset.categoria;

        // Verificar si ya fue asignado (doble seguridad)
        if (asignacionesBar[idElemento]) {
            mostrarFeedbackBar('Este elemento ya fue asignado.', 'error');
            // Limpiar selección
            elem.classList.remove('seleccionado');
            elementoSeleccionadoBar = null;
            document.querySelectorAll('.zona-bar').forEach(z => z.classList.remove('activa'));
            return;
        }

        if (categoriaDestino !== categoriaCorrecta) {
            // Error: shake en el elemento, flash rojo en zona
            elem.classList.add('shake');
            setTimeout(() => elem.classList.remove('shake'), 400);
            flashZona(zona, 'error');
            mostrarFeedbackBar('"' + nombreElemento + '" no pertenece a ' + categoriaDestino, 'error');
            // Limpiar selección
            elem.classList.remove('seleccionado');
            elementoSeleccionadoBar = null;
            document.querySelectorAll('.zona-bar').forEach(z => z.classList.remove('activa'));
            return;
        }

        // Asignación correcta
        asignacionesBar[idElemento] = categoriaDestino;
        elem.classList.remove('seleccionado');
        elem.classList.add('asignado');
        elem.setAttribute('aria-label', 'Asignado a ' + categoriaDestino);
        elementoSeleccionadoBar = null;
        document.querySelectorAll('.zona-bar').forEach(z => z.classList.remove('activa'));
        flashZona(zona, 'ok');

        const zonaId = zona.id.replace('zonaBar_', '');
        agregarElementoZona(zonaId, nombreElemento);

        mostrarFeedbackBar('✓ "' + nombreElemento + '" servido correctamente.', 'success');
        actualizarProgreso();

        if (Object.keys(asignacionesBar).length === totalElementosBar) {
            mostrarFeedbackBar('✅ ¡Todos los elementos han sido servidos!', 'success');
        }
    }

    // ----- Reiniciar actividad -----
    function reiniciarActividad() {
        if (Object.keys(asignacionesBar).length > 0 && !confirm('¿Seguro que quieres reiniciar la actividad? Se perderán todas las asignaciones.')) {
            return;
        }
        if (feedbackTimeout) clearTimeout(feedbackTimeout);
        asignacionesBar = {};
        elementoSeleccionadoBar = null;
        // Limpiar clases visuales de elementos
        document.querySelectorAll('.copa-elemento').forEach(e => {
            e.classList.remove('seleccionado', 'asignado', 'shake');
            e.setAttribute('aria-label', 'Elemento: ' + e.dataset.nombre);
        });
        // Limpiar zonas visualmente
        limpiarZonasVisuales();
        // Quitar resaltado de zonas activas
        document.querySelectorAll('.zona-bar').forEach(z => z.classList.remove('activa', 'drop-ok', 'drop-error'));
        // Deshabilitar botón enviar
        document.getElementById('btnEnviarBar').disabled = true;
        // Resetear feedback
        document.getElementById('feedbackBar').className = 'feedback-bar';
        actualizarProgreso();
        mostrarFeedbackBar('Actividad reiniciada', 'success');
    }

    // ----- Envío con prevención de duplicados -----
    function enviarBar() {
        if (enviando) return;
        if (Object.keys(asignacionesBar).length !== totalElementosBar) {
            mostrarFeedbackBar('❌ Asigna todos los elementos antes de enviar.', 'error');
            return;
        }
        enviando = true;
        const btn = document.getElementById('btnEnviarBar');
        btn.disabled = true;
        btn.innerHTML = '⏳ Sirviendo...';
        const respuestas = Object.entries(asignacionesBar).map(([idElemento, categoria]) => ({
            idElemento: parseInt(idElemento), categoria
        }));
        document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
        document.getElementById('formDnD').submit();
    }

    // ----- Asignar eventos después de cargar el DOM -----
    document.addEventListener('DOMContentLoaded', function() {
        // Eventos para elementos
        document.querySelectorAll('.copa-elemento').forEach(elem => {
            elem.addEventListener('click', (e) => {
                e.stopPropagation();
                seleccionarElementoBar(elem);
            });
            elem.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    seleccionarElementoBar(elem);
                }
            });
        });
        // Eventos para zonas
        document.querySelectorAll('.zona-bar').forEach(zona => {
            zona.addEventListener('click', (e) => {
                e.stopPropagation();
                asignarAZonaBar(zona);
            });
            zona.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    asignarAZonaBar(zona);
                }
            });
        });
        // Botón reiniciar
        document.getElementById('btnReiniciarBar').addEventListener('click', reiniciarActividad);
        // Botón enviar
        document.getElementById('btnEnviarBar').addEventListener('click', enviarBar);
        actualizarProgreso();
    });
</script>