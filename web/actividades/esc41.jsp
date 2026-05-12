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
    .horno-card { background: linear-gradient(135deg, #1a0a0a, #0a0a1a); border: 2px solid #5a2a2a; border-radius: 20px; padding: 32px; margin-bottom: 24px; }
    .horno-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: #ffcccc; margin-bottom: 8px; }
    .horno-desc { color: rgba(255,200,200,0.6); font-size: 13px; margin-bottom: 24px; }
    .horno-grid { display: flex; gap: 16px; flex-wrap: wrap; justify-content: center; margin: 20px 0; }
    .tarjeta-flip { width: 150px; height: 100px; perspective: 1000px; cursor: pointer; }
    .tarjeta-inner { position: relative; width: 100%; height: 100%; transition: transform 0.6s; transform-style: preserve-3d; }
    .tarjeta-flip.volteada .tarjeta-inner { transform: rotateY(180deg); }
    .tarjeta-frente, .tarjeta-dorso { position: absolute; width: 100%; height: 100%; backface-visibility: hidden; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 600; text-align: center; padding: 10px; }
    .tarjeta-frente { background: linear-gradient(135deg, #c0392b, #1a6699); color: white; border: 2px solid #e74c3c; font-size: 24px; }
    .tarjeta-dorso { background: #1a1a2e; color: #a0c4ff; border: 2px solid #4a90d9; transform: rotateY(180deg); font-size: 12px; }
    .tarjeta-flip.asignada .tarjeta-frente { opacity: 0.4; }
    .zonas-horno { display: flex; gap: 16px; flex-wrap: wrap; justify-content: center; margin-top: 24px; }
    .zona-horno { flex: 1; min-width: 150px; border-radius: 12px; padding: 16px; min-height: 120px; border: 2px dashed; text-align: center; transition: all 0.2s; cursor: pointer; }
    .zona-horno.caliente { background: rgba(231,76,60,0.1); border-color: #e74c3c; }
    .zona-horno.frio { background: rgba(74,144,217,0.1); border-color: #4a90d9; }
    .zona-horno h4 { margin-bottom: 10px; font-size: 13px; }
    .zona-horno.caliente h4 { color: #e74c3c; }
    .zona-horno.frio h4 { color: #4a90d9; }
    .zona-horno.activa { transform: scale(1.02); }
    .elem-asignado-horno { padding: 6px 10px; border-radius: 6px; font-size: 12px; margin: 4px; display: inline-block; color: white; }
    .elem-asignado-horno.caliente { background: #c0392b; }
    .elem-asignado-horno.frio { background: #1a6699; }
    .btn-horno { background: linear-gradient(135deg, #c0392b, #1a6699); color: white; border: none; border-radius: 8px; padding: 12px 28px; font-size: 14px; font-weight: 600; cursor: pointer; margin-top: 24px; transition: all 0.2s; font-family: 'DM Sans', sans-serif; }
    .btn-horno:hover { opacity: 0.9; transform: translateY(-1px); }
    .btn-horno:disabled { opacity: 0.4; cursor: not-allowed; transform: none; }
    .feedback-horno { margin-top: 16px; padding: 12px 16px; border-radius: 8px; font-size: 13px; display: none; }
    .feedback-horno.success { background: rgba(76,175,80,0.15); border-left: 4px solid #4caf50; color: #4caf50; display: block; }
    .feedback-horno.error { background: rgba(231,76,60,0.15); border-left: 4px solid #e74c3c; color: #e74c3c; display: block; }
</style>

<div class="horno-card">
    <h2 class="horno-titulo">🔥❄️ Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="horno-desc">Haz clic en cada tarjeta para revelar el elemento. Luego haz clic en la zona correcta para asignarlo.</p>
    <div class="horno-grid" id="hornoGrid">
        <% for (ElementoArrastrable e : elementos) {%>
        <div class="tarjeta-flip" id="tarjeta_<%= e.getIdElemento()%>"
             data-id="<%= e.getIdElemento()%>"
             data-nombre="<%= e.getNombre()%>"
             data-categoria-correcta="<%= e.getCategoriaCorrecta()%>"
             onclick="voltearTarjeta(this)">
            <div class="tarjeta-inner">
                <div class="tarjeta-frente">🃏</div>
                <div class="tarjeta-dorso"><%= e.getNombre()%></div>
            </div>
        </div>
        <% }%>
    </div>
    <div class="zonas-horno">
        <% for (CategoriaActividad cat : categorias) {
            String claseZona = cat.getNombreCategoria().toLowerCase().contains("calor")
                || cat.getNombreCategoria().toLowerCase().contains("caliente")
                || cat.getNombreCategoria().toLowerCase().contains("alto")
                || cat.getNombreCategoria().toLowerCase().contains("gas")
                ? "caliente" : "frio";
        %>
        <div class="zona-horno <%= claseZona%>" id="zonaH_<%= cat.getIdCategoria()%>"
             data-categoria="<%= cat.getNombreCategoria()%>"
             data-clase="<%= claseZona%>"
             onclick="asignarAZonaHorno(this)">
            <h4><%= cat.getNombreCategoria()%></h4>
            <div id="elemsZonaH_<%= cat.getIdCategoria()%>"></div>
        </div>
        <% }%>
    </div>
    <button class="btn-horno" id="btnEnviarHorno" disabled onclick="enviarHorno()">✅ Enviar clasificación</button>
    <div class="feedback-horno" id="feedbackHorno"></div>
    <form id="formDnD" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
        <input type="hidden" name="respuestas" id="respuestasJsonDnD">
    </form>
</div>

<script>
    let asignacionesHorno = {};
    let tarjetaSeleccionada = null;
    let totalElementosHorno = <%= elementos != null ? elementos.size() : 0%>;

    function voltearTarjeta(tarjeta) {
        if (tarjeta.classList.contains('asignada')) return;
        tarjeta.classList.toggle('volteada');
        if (tarjeta.classList.contains('volteada')) {
            document.querySelectorAll('.tarjeta-flip.volteada').forEach(t => { if (t !== tarjeta) t.classList.remove('volteada'); });
            tarjetaSeleccionada = tarjeta;
            document.querySelectorAll('.zona-horno').forEach(z => z.classList.add('activa'));
        } else {
            tarjetaSeleccionada = null;
            document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa'));
        }
    }

    function asignarAZonaHorno(zona) {
        if (!tarjetaSeleccionada) { mostrarFeedbackHorno('Primero haz clic en una tarjeta.', 'error'); return; }
        const idElemento = tarjetaSeleccionada.dataset.id;
        const nombreElemento = tarjetaSeleccionada.dataset.nombre;
        const categoriaCorrecta = tarjetaSeleccionada.dataset.categoriaCorrecta;
        const categoriaDestino = zona.dataset.categoria;
        if (categoriaDestino !== categoriaCorrecta) {
            mostrarFeedbackHorno('"' + nombreElemento + '" no pertenece aquí.', 'error');
            tarjetaSeleccionada.classList.remove('volteada');
            tarjetaSeleccionada = null;
            document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa'));
            return;
        }
        asignacionesHorno[idElemento] = categoriaDestino;
        tarjetaSeleccionada.classList.add('asignada');
        tarjetaSeleccionada.classList.remove('volteada');
        tarjetaSeleccionada = null;
        document.querySelectorAll('.zona-horno').forEach(z => z.classList.remove('activa'));
        const span = document.createElement('span');
        span.className = 'elem-asignado-horno ' + zona.dataset.clase;
        span.textContent = nombreElemento;
        document.getElementById('elemsZonaH_' + zona.id.replace('zonaH_', '')).appendChild(span);
        mostrarFeedbackHorno('✓ "' + nombreElemento + '" asignado.', 'success');
        if (Object.keys(asignacionesHorno).length === totalElementosHorno) {
            document.getElementById('btnEnviarHorno').disabled = false;
            mostrarFeedbackHorno('✅ ¡Todos clasificados!', 'success');
        }
    }

    function mostrarFeedbackHorno(mensaje, tipo) {
        const fb = document.getElementById('feedbackHorno');
        fb.textContent = mensaje; fb.className = 'feedback-horno ' + tipo;
        setTimeout(() => { fb.className = 'feedback-horno'; }, 3000);
    }

    function enviarHorno() {
        const respuestas = Object.entries(asignacionesHorno).map(([idElemento, categoria]) => ({idElemento: parseInt(idElemento), categoria}));
        document.getElementById('respuestasJsonDnD').value = JSON.stringify(respuestas);
        document.getElementById('formDnD').submit();
    }
</script>
