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
    .olla-card { background: linear-gradient(135deg, #1a1a1a, #2a2a2a); border: 2px solid #5a5a5a; border-radius: 20px; padding: 32px; margin-bottom: 24px; }
    .olla-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: #ffd700; margin-bottom: 8px; }
    .olla-desc { color: rgba(255,215,0,0.5); font-size: 13px; margin-bottom: 24px; }
    .olla-elementos { display: flex; flex-direction: column; gap: 16px; margin: 20px 0; }
    .olla-item { background: #2a2a2a; border: 2px solid #5a5a5a; border-radius: 12px; padding: 16px 20px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px; transition: all 0.2s; }
    .olla-item-nombre { font-size: 14px; color: #e0e0e0; font-weight: 600; flex: 1; min-width: 120px; }
    .olla-botones { display: flex; gap: 8px; flex-wrap: wrap; }
    .btn-olla-cat { padding: 8px 14px; border-radius: 8px; border: 2px solid #5a5a5a; background: #1a1a1a; color: #aaa; font-size: 12px; cursor: pointer; transition: all 0.2s; font-family: 'DM Sans', sans-serif; }
    .btn-olla-cat:hover { border-color: #ffd700; color: #ffd700; }
    .btn-olla-cat.correcto { border-color: #4caf50; background: rgba(76,175,80,0.15); color: #4caf50; }
    .btn-olla-cat.incorrecto { border-color: #f44336; background: rgba(244,67,54,0.15); color: #f44336; }
    .olla-item.asignado { border-color: #ffd700; background: rgba(255,215,0,0.05); }
    .btn-olla-enviar { background: linear-gradient(135deg, #5a5a5a, #ffd700); color: #1a1a1a; border: none; border-radius: 8px; padding: 12px 28px; font-size: 14px; font-weight: 700; cursor: pointer; margin-top: 24px; transition: all 0.2s; font-family: 'DM Sans', sans-serif; }
    .btn-olla-enviar:hover { opacity: 0.9; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(255,215,0,0.3); }
    .btn-olla-enviar:disabled { opacity: 0.3; cursor: not-allowed; transform: none; }
    .feedback-olla { margin-top: 16px; padding: 12px 16px; border-radius: 8px; font-size: 13px; display: none; }
    .feedback-olla.success { background: rgba(76,175,80,0.1); border-left: 4px solid #4caf50; color: #4caf50; display: block; }
    .feedback-olla.error { background: rgba(244,67,54,0.1); border-left: 4px solid #f44336; color: #f44336; display: block; }
</style>

<div class="olla-card">
    <h2 class="olla-titulo">⚗️ Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="olla-desc">Para cada elemento, selecciona la categoría correcta presionando el botón correspondiente.</p>
    <div class="olla-elementos">
        <% for (ElementoArrastrable e : elementos) {%>
        <div class="olla-item" id="ollaItem_<%= e.getIdElemento()%>"
             data-id="<%= e.getIdElemento()%>"
             data-categoria-correcta="<%= e.getCategoriaCorrecta()%>">
            <span class="olla-item-nombre">⚙️ <%= e.getNombre()%></span>
            <div class="olla-botones">
                <% for (CategoriaActividad cat : categorias) {%>
                <button class="btn-olla-cat"
                        data-elemento-id="<%= e.getIdElemento()%>"
                        data-categoria="<%= cat.getNombreCategoria()%>"
                        onclick="seleccionarCategoriaOlla(this)">
                    <%= cat.getNombreCategoria()%>
                </button>
                <% }%>
            </div>
        </div>
        <% }%>
    </div>
    <button class="btn-olla-enviar" id="btnEnviarOlla" disabled onclick="enviarOlla()">✅ Confirmar clasificación</button>
    <div class="feedback-olla" id="feedbackOlla"></div>
    <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
        <input type="hidden" name="respuestas" id="respuestasJsonDnD">
    </form>
</div>

<script>
    let asignacionesOlla = {};
    let totalElementosOlla = <%= elementos != null ? elementos.size() : 0%>;

    function seleccionarCategoriaOlla(btn) {
        const idElemento = btn.dataset.elementoId;
        const categoria = btn.dataset.categoria;
        const item = document.getElementById('ollaItem_' + idElemento);
        const categoriaCorrecta = item.dataset.categoriaCorrecta;
        document.querySelectorAll('.btn-olla-cat[data-elemento-id="' + idElemento + '"]').forEach(b => b.classList.remove('correcto', 'incorrecto'));
        if (categoria === categoriaCorrecta) {
            btn.classList.add('correcto');
            asignacionesOlla[idElemento] = categoria;
            item.classList.add('asignado');
            mostrarFeedbackOlla('✓ Correcto.', 'success');
        } else {
            btn.classList.add('incorrecto');
            delete asignacionesOlla[idElemento];
            mostrarFeedbackOlla('✗ Incorrecto, intenta de nuevo.', 'error');
        }
        if (Object.keys(asignacionesOlla).length === totalElementosOlla) {
            document.getElementById('btnEnviarOlla').disabled = false;
            mostrarFeedbackOlla('✅ ¡Todo clasificado!', 'success');
        }
    }

    function mostrarFeedbackOlla(mensaje, tipo) {
        const fb = document.getElementById('feedbackOlla');
        fb.textContent = mensaje; fb.className = 'feedback-olla ' + tipo;
        setTimeout(() => { fb.className = 'feedback-olla'; }, 3000);
    }

    function enviarOlla() {
        const respuestas = Object.entries(asignacionesOlla).map(([idElemento, categoria]) => ({idElemento: parseInt(idElemento), categoria}));
        document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
        document.getElementById('formDnD').submit();
    }
</script>