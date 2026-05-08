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
    .bar-card { background: linear-gradient(135deg, #0d0d1a, #1a0d2e); border: 2px solid #4a1a7a; border-radius: 20px; padding: 32px; margin-bottom: 24px; }
    .bar-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: #e0aaff; margin-bottom: 8px; }
    .bar-desc { color: rgba(224,170,255,0.6); font-size: 13px; margin-bottom: 24px; }
    .bar-elementos { display: flex; flex-wrap: wrap; gap: 12px; justify-content: center; margin: 20px 0; }
    .copa-elemento { background: linear-gradient(135deg, #2d1a4a, #1a2d4a); border: 2px solid #7b2fff; border-radius: 12px; padding: 16px 20px; cursor: pointer; font-size: 14px; color: #e0aaff; transition: all 0.3s; text-align: center; min-width: 120px; }
    .copa-elemento:hover { border-color: #00f5d4; color: #00f5d4; transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,245,212,0.2); }
    .copa-elemento.seleccionado { border-color: #00f5d4; background: linear-gradient(135deg, #1a3a3a, #2a1a4a); color: #00f5d4; box-shadow: 0 0 15px rgba(0,245,212,0.3); }
    .copa-elemento.asignado { border-color: #4caf50; background: linear-gradient(135deg, #1a2e1a, #1a2e1a); color: #4caf50; pointer-events: none; }
    .bar-zonas { display: flex; gap: 16px; flex-wrap: wrap; justify-content: center; margin-top: 24px; }
    .zona-bar { flex: 1; min-width: 140px; border-radius: 12px; padding: 16px; min-height: 110px; border: 2px dashed #4a1a7a; background: rgba(74,26,122,0.1); text-align: center; transition: all 0.2s; cursor: pointer; }
    .zona-bar h4 { color: #7b2fff; font-size: 13px; margin-bottom: 10px; }
    .zona-bar:hover { border-color: #00f5d4; background: rgba(0,245,212,0.05); }
    .zona-bar.activa { border-color: #00f5d4; background: rgba(0,245,212,0.08); transform: scale(1.02); }
    .elem-asignado-bar { padding: 5px 10px; border-radius: 20px; font-size: 11px; margin: 3px; display: inline-block; background: rgba(0,245,212,0.15); color: #00f5d4; border: 1px solid #00f5d4; }
    .btn-bar { background: linear-gradient(135deg, #7b2fff, #00f5d4); color: white; border: none; border-radius: 50px; padding: 12px 28px; font-size: 14px; font-weight: 600; cursor: pointer; margin-top: 24px; transition: all 0.2s; font-family: 'DM Sans', sans-serif; }
    .btn-bar:hover { opacity: 0.9; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(123,47,255,0.4); }
    .btn-bar:disabled { opacity: 0.3; cursor: not-allowed; transform: none; }
    .feedback-bar { margin-top: 16px; padding: 12px 16px; border-radius: 8px; font-size: 13px; display: none; }
    .feedback-bar.success { background: rgba(0,245,212,0.1); border-left: 4px solid #00f5d4; color: #00f5d4; display: block; }
    .feedback-bar.error { background: rgba(255,50,50,0.1); border-left: 4px solid #ff3232; color: #ff3232; display: block; }
</style>

<div class="bar-card">
    <h2 class="bar-titulo">🍹 Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="bar-desc">Selecciona un elemento y luego haz clic en la categoría donde pertenece.</p>
    <div class="bar-elementos" id="barElementos">
        <% for (ElementoArrastrable e : elementos) {%>
        <div class="copa-elemento" id="barElem_<%= e.getIdElemento()%>"
             data-id="<%= e.getIdElemento()%>"
             data-nombre="<%= e.getNombre()%>"
             data-categoria-correcta="<%= e.getCategoriaCorrecta()%>"
             onclick="seleccionarElementoBar(this)">
            🧪 <%= e.getNombre()%>
        </div>
        <% }%>
    </div>
    <div class="bar-zonas">
        <% for (CategoriaActividad cat : categorias) {%>
        <div class="zona-bar" id="zonaBar_<%= cat.getIdCategoria()%>"
             data-categoria="<%= cat.getNombreCategoria()%>"
             onclick="asignarAZonaBar(this)">
            <h4>🏷️ <%= cat.getNombreCategoria()%></h4>
            <div id="elemsZonaBar_<%= cat.getIdCategoria()%>"></div>
        </div>
        <% }%>
    </div>
    <button class="btn-bar" id="btnEnviarBar" disabled onclick="enviarBar()">✅ Servir respuestas</button>
    <div class="feedback-bar" id="feedbackBar"></div>
    <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
        <input type="hidden" name="respuestas" id="respuestasJsonDnD">
    </form>
</div>

<script>
    let asignacionesBar = {};
    let elementoSeleccionadoBar = null;
    let totalElementosBar = <%= elementos != null ? elementos.size() : 0%>;

    function seleccionarElementoBar(elem) {
        if (elem.classList.contains('asignado')) return;
        document.querySelectorAll('.copa-elemento').forEach(e => e.classList.remove('seleccionado'));
        if (elementoSeleccionadoBar === elem) { elementoSeleccionadoBar = null; return; }
        elementoSeleccionadoBar = elem;
        elem.classList.add('seleccionado');
        document.querySelectorAll('.zona-bar').forEach(z => z.classList.add('activa'));
    }

    function asignarAZonaBar(zona) {
        if (!elementoSeleccionadoBar) { mostrarFeedbackBar('Primero selecciona un elemento.', 'error'); return; }
        const idElemento = elementoSeleccionadoBar.dataset.id;
        const nombreElemento = elementoSeleccionadoBar.dataset.nombre;
        const categoriaCorrecta = elementoSeleccionadoBar.dataset.categoriaCorrecta;
        const categoriaDestino = zona.dataset.categoria;
        if (categoriaDestino !== categoriaCorrecta) {
            mostrarFeedbackBar('"' + nombreElemento + '" no va aquí.', 'error');
            elementoSeleccionadoBar.classList.remove('seleccionado');
            elementoSeleccionadoBar = null;
            document.querySelectorAll('.zona-bar').forEach(z => z.classList.remove('activa'));
            return;
        }
        asignacionesBar[idElemento] = categoriaDestino;
        elementoSeleccionadoBar.classList.remove('seleccionado');
        elementoSeleccionadoBar.classList.add('asignado');
        elementoSeleccionadoBar = null;
        document.querySelectorAll('.zona-bar').forEach(z => z.classList.remove('activa'));
        const span = document.createElement('span');
        span.className = 'elem-asignado-bar';
        span.textContent = nombreElemento;
        document.getElementById('elemsZonaBar_' + zona.id.replace('zonaBar_', '')).appendChild(span);
        mostrarFeedbackBar('✓ "' + nombreElemento + '" servido.', 'success');
        if (Object.keys(asignacionesBar).length === totalElementosBar) {
            document.getElementById('btnEnviarBar').disabled = false;
            mostrarFeedbackBar('✅ ¡Todos servidos!', 'success');
        }
    }

    function mostrarFeedbackBar(mensaje, tipo) {
        const fb = document.getElementById('feedbackBar');
        fb.textContent = mensaje; fb.className = 'feedback-bar ' + tipo;
        setTimeout(() => { fb.className = 'feedback-bar'; }, 3000);
    }

    function enviarBar() {
        const respuestas = Object.entries(asignacionesBar).map(([idElemento, categoria]) => ({idElemento: parseInt(idElemento), categoria}));
        document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
        document.getElementById('formDnD').submit();
    }
</script>