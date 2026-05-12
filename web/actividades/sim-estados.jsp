<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.PreguntaSimulacionEstados, com.chefmolecular.modelo.ActividadInteractiva, java.util.List" %>
<%
    List<PreguntaSimulacionEstados> preguntas = (List<PreguntaSimulacionEstados>) request.getAttribute("preguntas");
    PreguntaSimulacionEstados preguntaActual = (preguntas != null && !preguntas.isEmpty()) ? preguntas.get(0) : null;
    int actividadIdx = (int) request.getAttribute("actividadIdx");
    int totalActividades = (int) request.getAttribute("totalActividades");
    int idEscenario = (int) request.getAttribute("idEscenario");
    ActividadInteractiva actividad = (ActividadInteractiva) request.getAttribute("actividad");
%>
<!-- SIM-DEBUG: preguntas=<%= preguntas != null ? preguntas.size() : "NULL" %> -->
<!-- SIM-DEBUG: preguntaId=<%= preguntaActual != null ? preguntaActual.getIdPregunta() : "NULL" %> -->
<!-- SIM-DEBUG: actividadId=<%= actividad != null ? actividad.getIdActividad() : "NULL" %> -->
<style>
    .actividad-card {
        background: var(--bg-card);
        border: 1px solid var(--border);
        border-radius: 16px;
        padding: 32px;
        margin-bottom: 24px;
    }
    .actividad-titulo {
        font-family: 'Playfair Display', serif;
        font-size: 1.5rem;
        margin-bottom: 8px;
    }
    .actividad-desc {
        color: var(--text-dim);
        font-size: 13px;
        margin-bottom: 24px;
    }
</style>

<div class="actividad-card">
    <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="actividad-desc">🌡️ Mueve el deslizador para cambiar la temperatura y observa cómo se comportan las partículas.</p>
    <div style="text-align:center; margin:20px 0;">
        <canvas id="canvasEstados" width="500" height="200" style="background:#f0f0f0; border-radius:8px;"></canvas>
        <div style="margin-top:10px;">
            <input type="range" id="tempSlider" min="-50" max="150" value="25" step="1" oninput="actualizarTemperatura(this.value)">
            <span id="tempLabel">25 °C</span>
            <span id="estadoLabel" style="margin-left:20px; font-weight:bold;">Líquido</span>
        </div>
    </div>
    <% if (preguntaActual != null) {%>
    <div style="margin-top:30px;">
        <h4><%= preguntaActual.getEnunciado()%></h4>
        <div style="display:flex; gap:20px; justify-content:center; margin-top:15px; flex-wrap:wrap;">
            <button onclick="seleccionarOpcion(1, event)" class="btn-opcion">A. <%= preguntaActual.getOpcionA()%></button>
            <button onclick="seleccionarOpcion(2, event)" class="btn-opcion">B. <%= preguntaActual.getOpcionB()%></button>
            <button onclick="seleccionarOpcion(3, event)" class="btn-opcion">C. <%= preguntaActual.getOpcionC()%></button>
            <button onclick="seleccionarOpcion(4, event)" class="btn-opcion">D. <%= preguntaActual.getOpcionD()%></button>
        </div>
    </div>
    <% } else { %>
    <p style="color:red;">Error: no se cargó la pregunta. Vuelve al menú e intenta de nuevo.</p>
    <% }%>
    <div style="margin-top:30px;">
        <button class="btn-accion" id="btnEnviarEstados" disabled onclick="enviarRespuesta()">✅ Enviar respuesta</button>
    </div>
    <form id="formSimulacionEstados" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
        <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
        <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
        <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
        <input type="hidden" name="respuestas" id="respuestasEstadosJson">
    </form>
</div>

<script>
    const canvasEstados = document.getElementById('canvasEstados');
    const ctxEstados = canvasEstados.getContext('2d');
    let temperatura = 25, opcionSeleccionada = 0;
    let particulas = [];
    for (let i = 0; i < 20; i++)
        particulas.push({x: Math.random() * canvasEstados.width, y: Math.random() * canvasEstados.height, vx: (Math.random() - 0.5) * 2, vy: (Math.random() - 0.5) * 2, radio: 4});

    function actualizarTemperatura(valor) {
        temperatura = parseInt(valor);
        document.getElementById('tempLabel').textContent = valor + ' °C';
        let estado = 'Sólido';
        if (temperatura > 0 && temperatura < 100)
            estado = 'Líquido';
        else if (temperatura >= 100)
            estado = 'Gas';
        document.getElementById('estadoLabel').textContent = estado;
    }

    function animar() {
        ctxEstados.clearRect(0, 0, canvasEstados.width, canvasEstados.height);
        let vMax = temperatura <= 0 ? 0.1 : temperatura < 100 ? 1.5 : 4;
        particulas.forEach(p => {
            p.vx += (Math.random() - 0.5) * 0.2;
            p.vy += (Math.random() - 0.5) * 0.2;
            let vel = Math.sqrt(p.vx * p.vx + p.vy * p.vy);
            if (vel > vMax) {
                p.vx = (p.vx / vel) * vMax;
                p.vy = (p.vy / vel) * vMax;
            }
            if (temperatura <= 0) {
                let px = (p.x % 100) + 10, py = (p.y % 100) + 10;
                p.vx += (px - p.x) * 0.01;
                p.vy += (py - p.y) * 0.01;
            }
            p.x += p.vx;
            p.y += p.vy;
            if (p.x < 0 || p.x > canvasEstados.width)
                p.vx *= -1;
            if (p.y < 0 || p.y > canvasEstados.height)
                p.vy *= -1;
            ctxEstados.beginPath();
            ctxEstados.arc(p.x, p.y, p.radio, 0, Math.PI * 2);
            ctxEstados.fillStyle = '#4CAF50';
            ctxEstados.fill();
        });
        requestAnimationFrame(animar);
    }
    animar();

    function seleccionarOpcion(opcion, event) {
        opcionSeleccionada = opcion;
        document.getElementById('btnEnviarEstados').disabled = false;
        document.querySelectorAll('.btn-opcion').forEach(b => b.style.background = '');
        event.target.style.background = '#c8e6c9';
    }

    function enviarRespuesta() {
    if (opcionSeleccionada === 0) return;
    const preguntaId = <%= preguntaActual != null ? preguntaActual.getIdPregunta() : 0%>;
    if (preguntaId === 0) {
        alert("Error: pregunta no cargada correctamente.");
        return;
    }
    document.getElementById('respuestasEstadosJson').value = JSON.stringify([{idPregunta: preguntaId, opcionSeleccionada: opcionSeleccionada}]);
    document.getElementById('formSimulacionEstados').submit();
}
</script>
