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
    .olla-card { background: linear-gradient(135deg, #1a1a1a, #2a2a2a); border: 2px solid #5a5a5a; border-radius: 20px; padding: 32px; margin-bottom: 24px; }
    .olla-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: #ffd700; margin-bottom: 8px; }
    .olla-desc { color: rgba(255,215,0,0.5); font-size: 13px; margin-bottom: 24px; }

    /* Barra de progreso */
    .progreso-wrapper { margin-bottom: 20px; }
    .progreso-texto { font-size: 13px; color: rgba(255,215,0,0.7); margin-bottom: 6px; display: flex; justify-content: space-between; }
    .progreso-texto span { font-weight: 600; color: #ffd700; }
    .progreso-barra-bg { background: rgba(90,90,90,0.3); border-radius: 99px; height: 8px; overflow: hidden; }
    .progreso-barra-fill { height: 100%; background: linear-gradient(90deg, #ffd700, #ffaa00); border-radius: 99px; width: 0%; transition: width 0.4s ease; }

    /* Elementos (cada ítem con sus botones) */
    .olla-elementos { display: flex; flex-direction: column; gap: 16px; margin: 20px 0; }
    .olla-item { background: #2a2a2a; border: 2px solid #5a5a5a; border-radius: 12px; padding: 16px 20px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px; transition: all 0.2s; }
    .olla-item.asignado { border-color: #ffd700; background: rgba(255,215,0,0.05); box-shadow: 0 0 8px rgba(255,215,0,0.2); }
    .olla-item-nombre { font-size: 14px; color: #e0e0e0; font-weight: 600; flex: 1; min-width: 120px; }
    .olla-botones { display: flex; gap: 8px; flex-wrap: wrap; }

    /* Botones de categoría */
    .btn-olla-cat { padding: 8px 14px; border-radius: 8px; border: 2px solid #5a5a5a; background: #1a1a1a; color: #aaa; font-size: 12px; cursor: pointer; transition: all 0.2s; font-family: 'DM Sans', sans-serif; user-select: none; }
    .btn-olla-cat:hover { border-color: #ffd700; color: #ffd700; transform: scale(1.02); }
    .btn-olla-cat:focus-visible { outline: 2px solid #ffd700; outline-offset: 2px; }
    .btn-olla-cat.correcto { border-color: #4caf50; background: rgba(76,175,80,0.2); color: #4caf50; box-shadow: 0 0 0 2px rgba(76,175,80,0.3); animation: pulseCorrect 0.4s ease; }
    .btn-olla-cat.incorrecto { border-color: #f44336; background: rgba(244,67,54,0.2); color: #f44336; animation: shake 0.35s ease; }
    @keyframes pulseCorrect { 0% { transform: scale(1); } 50% { transform: scale(1.05); } 100% { transform: scale(1); } }
    @keyframes shake { 0%,100% { transform: translateX(0); } 20% { transform: translateX(-4px); } 40% { transform: translateX(4px); } 60% { transform: translateX(-2px); } 80% { transform: translateX(2px); } }

    /* Botones de acción generales - alineados */
    .acciones-bar { display: flex; justify-content: flex-end; gap: 16px; margin-top: 28px; flex-wrap: wrap; }
    .btn-olla-enviar, .btn-reiniciar { padding: 12px 28px; border-radius: 8px; font-weight: 700; cursor: pointer; transition: all 0.2s; font-size: 14px; border: none; font-family: 'DM Sans', sans-serif; }
    .btn-olla-enviar { background: linear-gradient(135deg, #5a5a5a, #ffd700); color: #1a1a1a; box-shadow: 0 2px 6px rgba(0,0,0,0.3); }
    .btn-olla-enviar:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(255,215,0,0.3); }
    .btn-olla-enviar:disabled { opacity: 0.3; cursor: not-allowed; transform: none; }
    .btn-reiniciar { background: transparent; border: 2px solid #5a5a5a; color: #ffd700; }
    .btn-reiniciar:hover { border-color: #ffd700; background: rgba(255,215,0,0.1); }

    /* Feedback */
    .feedback-olla { margin-top: 16px; padding: 12px 16px; border-radius: 8px; font-size: 13px; display: none; }
    .feedback-olla.success { background: rgba(76,175,80,0.1); border-left: 4px solid #4caf50; color: #4caf50; display: block; }
    .feedback-olla.error { background: rgba(244,67,54,0.1); border-left: 4px solid #f44336; color: #f44336; display: block; }

    /* Responsive */
    @media (max-width: 600px) {
        .olla-card { padding: 20px; }
        .olla-item { flex-direction: column; align-items: stretch; }
        .olla-botones { justify-content: center; }
        .acciones-bar { justify-content: stretch; }
        .acciones-bar button { flex: 1; text-align: center; }
    }

    /* Accesibilidad */
    .sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); border: 0; }
</style>

<div class="olla-card">
    <h2 class="olla-titulo">⚗️ Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="olla-desc">Para cada elemento, selecciona la categoría correcta presionando el botón correspondiente.</p>

    <!-- Barra de progreso -->
    <div class="progreso-wrapper">
        <div class="progreso-texto">
            <span id="progresoLabel">0 de <%= elementos.size() %> clasificados</span>
            <span id="progresoPorc">0%</span>
        </div>
        <div class="progreso-barra-bg">
            <div class="progreso-barra-fill" id="progresoBarra"></div>
        </div>
    </div>

    <div class="olla-elementos" id="ollaElementos" role="group" aria-label="Lista de elementos para clasificar">
        <% for (ElementoArrastrable e : elementos) { %>
            <div class="olla-item" id="ollaItem_<%= e.getIdElemento() %>"
                 data-id="<%= e.getIdElemento() %>"
                 data-categoria-correcta="<%= e.getCategoriaCorrecta() %>">
                <span class="olla-item-nombre">⚙️ <%= e.getNombre() %></span>
                <div class="olla-botones" role="group" aria-label="Opciones de categoría para <%= e.getNombre() %>">
                    <% for (CategoriaActividad cat : categorias) { %>
                        <button class="btn-olla-cat"
                                data-elemento-id="<%= e.getIdElemento() %>"
                                data-categoria="<%= cat.getNombreCategoria() %>"
                                aria-label="Asignar <%= e.getNombre() %> a <%= cat.getNombreCategoria() %>">
                            <%= cat.getNombreCategoria() %>
                        </button>
                    <% } %>
                </div>
            </div>
        <% } %>
    </div>

    <div class="acciones-bar">
        <button class="btn-reiniciar" id="btnReiniciarOlla" aria-label="Reiniciar actividad">🔄 Reiniciar</button>
        <button class="btn-olla-enviar" id="btnEnviarOlla" disabled aria-label="Enviar respuestas">✅ Confirmar clasificación</button>
    </div>
    <div class="feedback-olla" id="feedbackOlla" role="status"></div>

    <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario %>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad() %>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx %>">
        <input type="hidden" name="respuestas" id="respuestasJsonDnD">
    </form>
</div>

<script>
    let asignacionesOlla = {};
    let totalElementosOlla = <%= elementos != null ? elementos.size() : 0 %>;
    let feedbackTimeout = null;
    let enviando = false;

    // ----- Funciones auxiliares -----
    function mostrarFeedbackOlla(mensaje, tipo) {
        const fb = document.getElementById('feedbackOlla');
        if (!fb) return;
        if (feedbackTimeout) clearTimeout(feedbackTimeout);
        fb.textContent = mensaje;
        fb.className = 'feedback-olla ' + tipo;
        feedbackTimeout = setTimeout(() => { fb.className = 'feedback-olla'; }, 3000);
    }

    function actualizarProgreso() {
        const clasificados = Object.keys(asignacionesOlla).length;
        const pct = Math.round((clasificados / totalElementosOlla) * 100);
        document.getElementById('progresoLabel').textContent = clasificados + ' de ' + totalElementosOlla + ' clasificados';
        document.getElementById('progresoPorc').textContent = pct + '%';
        document.getElementById('progresoBarra').style.width = pct + '%';
        const btnEnviar = document.getElementById('btnEnviarOlla');
        if (btnEnviar && !enviando) btnEnviar.disabled = (clasificados !== totalElementosOlla);
    }

    // ----- Selección de categoría para un elemento -----
    function seleccionarCategoriaOlla(btn) {
        if (enviando) return; // No permitir cambios durante envío
        const idElemento = btn.dataset.elementoId;
        const categoria = btn.dataset.categoria;
        const item = document.getElementById('ollaItem_' + idElemento);
        const categoriaCorrecta = item.dataset.categoriaCorrecta;
        const botonesGrupo = document.querySelectorAll(`.btn-olla-cat[data-elemento-id="${idElemento}"]`);

        // Si el elemento ya tiene una asignación y es la misma categoría, no hacer nada
        if (asignacionesOlla[idElemento] === categoria) {
            mostrarFeedbackOlla('Ya has asignado este elemento a "' + categoria + '".', 'error');
            return;
        }

        // Quitar clases previas de todos los botones de este elemento
        botonesGrupo.forEach(b => b.classList.remove('correcto', 'incorrecto'));

        if (categoria === categoriaCorrecta) {
            // Asignación correcta
            btn.classList.add('correcto');
            asignacionesOlla[idElemento] = categoria;
            item.classList.add('asignado');
            // Anuncio para lectores de pantalla
            const anuncio = document.createElement('div');
            anuncio.className = 'sr-only';
            anuncio.textContent = 'Correcto! ' + item.querySelector('.olla-item-nombre').textContent + ' asignado a ' + categoria;
            document.body.appendChild(anuncio);
            setTimeout(() => anuncio.remove(), 1500);
            mostrarFeedbackOlla('✓ Correcto!', 'success');
            // Verificar si ya completó todos
            if (Object.keys(asignacionesOlla).length === totalElementosOlla) {
                mostrarFeedbackOlla('✅ ¡Todos los elementos han sido clasificados correctamente!', 'success');
            }
        } else {
            // Asignación incorrecta
            btn.classList.add('incorrecto');
            // Eliminar asignación previa si existía
            if (asignacionesOlla[idElemento]) {
                delete asignacionesOlla[idElemento];
                item.classList.remove('asignado');
            }
            mostrarFeedbackOlla('✗ Incorrecto. "' + categoria + '" no es la categoría correcta.', 'error');
        }
        actualizarProgreso();
    }

    // ----- Reiniciar actividad -----
    function reiniciarActividad() {
        if (Object.keys(asignacionesOlla).length > 0 && !confirm('¿Seguro que quieres reiniciar la actividad? Se perderán todas las clasificaciones.')) {
            return;
        }
        if (feedbackTimeout) clearTimeout(feedbackTimeout);
        asignacionesOlla = {};
        // Limpiar clases visuales
        document.querySelectorAll('.olla-item').forEach(item => {
            item.classList.remove('asignado');
        });
        document.querySelectorAll('.btn-olla-cat').forEach(btn => {
            btn.classList.remove('correcto', 'incorrecto');
        });
        document.getElementById('btnEnviarOlla').disabled = true;
        document.getElementById('feedbackOlla').className = 'feedback-olla';
        actualizarProgreso();
        mostrarFeedbackOlla('Actividad reiniciada', 'success');
    }

    // ----- Envío con prevención de duplicados -----
    function enviarOlla() {
        if (enviando) return;
        if (Object.keys(asignacionesOlla).length !== totalElementosOlla) {
            mostrarFeedbackOlla('❌ Clasifica todos los elementos antes de confirmar.', 'error');
            return;
        }
        enviando = true;
        const btn = document.getElementById('btnEnviarOlla');
        btn.disabled = true;
        btn.innerHTML = '⏳ Confirmando...';
        const respuestas = Object.entries(asignacionesOlla).map(([idElemento, categoria]) => ({
            idElemento: parseInt(idElemento), categoria
        }));
        document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
        document.getElementById('formDnD').submit();
    }

    // ----- Configuración de eventos (incluyendo teclado) -----
    document.addEventListener('DOMContentLoaded', function() {
        // Asignar eventos click y teclado a todos los botones de categoría
        document.querySelectorAll('.btn-olla-cat').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                seleccionarCategoriaOlla(btn);
            });
            btn.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    seleccionarCategoriaOlla(btn);
                }
            });
        });
        // Botón reiniciar
        const btnReiniciar = document.getElementById('btnReiniciarOlla');
        if (btnReiniciar) btnReiniciar.addEventListener('click', reiniciarActividad);
        // Botón enviar
        const btnEnviar = document.getElementById('btnEnviarOlla');
        if (btnEnviar) btnEnviar.addEventListener('click', enviarOlla);
        actualizarProgreso();
    });
</script>