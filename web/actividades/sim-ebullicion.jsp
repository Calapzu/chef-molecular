<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.chefmolecular.modelo.PreguntaSimulacionEbullicion, com.chefmolecular.modelo.ActividadInteractiva, java.util.List" %>
<%
    List<PreguntaSimulacionEbullicion> preguntas = (List<PreguntaSimulacionEbullicion>) request.getAttribute("preguntas");
    int actividadIdx = (int) request.getAttribute("actividadIdx");
    int totalActividades = (int) request.getAttribute("totalActividades");
    int idEscenario = (int) request.getAttribute("idEscenario");
    ActividadInteractiva actividad = (ActividadInteractiva) request.getAttribute("actividad");
%>
<% if (preguntas == null || preguntas.isEmpty()) {%>
<p>No hay preguntas disponibles.</p>
<% } else {%>
<style>
    .actividad-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 16px; padding: 32px; margin-bottom: 24px; }
    .actividad-titulo { font-family: 'Playfair Display', serif; font-size: 1.5rem; margin-bottom: 8px; }
    .actividad-desc { color: var(--text-dim); font-size: 13px; margin-bottom: 24px; }
    #altitudSlider { width: 200px; margin: 0 15px; vertical-align: middle; }
    #altitudLabel, #tempEbullicionLabel { font-size: 14px; color: var(--text-ppal); }
</style>
<div class="actividad-card">
    <h2 class="actividad-titulo">Actividad <%= actividadIdx + 1%> de <%= totalActividades%></h2>
    <p class="actividad-desc">🌋 Ajustá la altitud con el deslizador y observá cómo cambia la temperatura de ebullición.</p>
    <div style="text-align:center; margin:20px 0;">
        <canvas id="canvasEbullicion" width="400" height="200" style="background:#fff3e0; border-radius:8px;"></canvas>
        <div style="margin-top:10px;">
            <input type="range" id="altitudSlider" min="0" max="4000" value="0" step="100" oninput="actualizarAltitud(this.value)">
            <span id="altitudLabel">0 m</span>
            <span id="tempEbullicionLabel" style="margin-left:20px; font-weight:bold;">100 °C</span>
        </div>
    </div>
    <% for (PreguntaSimulacionEbullicion pregunta : preguntas) {%>
    <div style="margin:30px 0;">
        <h4><%= pregunta.getEnunciado()%></h4>
        <div style="display:flex; gap:15px; justify-content:center; margin-top:10px;">
            <button class="btn-opcion" data-pregunta="<%= pregunta.getIdPregunta()%>" data-opcion="1">A. <%= pregunta.getOpcionA()%></button>
            <button class="btn-opcion" data-pregunta="<%= pregunta.getIdPregunta()%>" data-opcion="2">B. <%= pregunta.getOpcionB()%></button>
            <button class="btn-opcion" data-pregunta="<%= pregunta.getIdPregunta()%>" data-opcion="3">C. <%= pregunta.getOpcionC()%></button>
            <button class="btn-opcion" data-pregunta="<%= pregunta.getIdPregunta()%>" data-opcion="4">D. <%= pregunta.getOpcionD()%></button>
        </div>
    </div>
    <% }%>
    <button class="btn-accion" id="btnEnviarEbullicion" onclick="enviarRespuestasEbullicion()">✅ Enviar respuestas</button>
    <div id="feedbackEbullicion" style="margin-top:15px;"></div>
</div>
<form id="formEbullicion" style="display:none;" action="${pageContext.request.contextPath}/actividad" method="post">
    <input type="hidden" name="idEscenario" value="<%= idEscenario%>">
    <input type="hidden" name="idActividad" value="<%= actividad.getIdActividad()%>">
    <input type="hidden" name="actividadIdx" value="<%= actividadIdx%>">
    <input type="hidden" name="respuestas" id="respuestasEbullicionJson">
</form>

<script>
    const canvasEb=document.getElementById('canvasEbullicion');
    const ctxEb=canvasEb.getContext('2d');
    let altitud=0, temperaturaEbullicion=100, respuestasEbullicion={};

    function dibujarOlla(temp) {
        ctxEb.clearRect(0,0,canvasEb.width,canvasEb.height);
        ctxEb.fillStyle='#bdbdbd'; ctxEb.fillRect(150,80,100,70);
        ctxEb.fillStyle='#ff7043'; ctxEb.fillRect(170,60,60,20);
        ctxEb.fillStyle='#fff'; ctxEb.fillRect(60,30,20,120);
        ctxEb.fillStyle='#f44336';
        let alturaTemp=(temp-70)*(100/60);
        ctxEb.fillRect(65,150-alturaTemp,10,alturaTemp);
        ctxEb.fillStyle='#000'; ctxEb.font='12px sans-serif';
        ctxEb.fillText(temp+' °C',90,150-alturaTemp-5);
        if (temp>=90){ctxEb.fillStyle='rgba(255,255,255,0.6)';for(let i=0;i<5;i++){ctxEb.beginPath();ctxEb.arc(180+Math.random()*40,70+Math.random()*30,3,0,Math.PI*2);ctxEb.fill();}}
    }

    function actualizarAltitud(valor) {
        altitud=parseInt(valor); document.getElementById('altitudLabel').textContent=altitud+' m';
        if (altitud<=0) temperaturaEbullicion=100;
        else if (altitud<=2000) temperaturaEbullicion=100-(altitud/1000)*5;
        else temperaturaEbullicion=100-10-(altitud-2000)/1000*2;
        temperaturaEbullicion=Math.round(temperaturaEbullicion*10)/10;
        document.getElementById('tempEbullicionLabel').textContent=temperaturaEbullicion+' °C';
        dibujarOlla(temperaturaEbullicion);
    }

    document.querySelectorAll('.btn-opcion').forEach(btn => {
        btn.addEventListener('click', function() {
            const preguntaId=parseInt(this.dataset.pregunta), opcion=parseInt(this.dataset.opcion);
            respuestasEbullicion[preguntaId]=opcion;
            document.querySelectorAll('.btn-opcion[data-pregunta="'+preguntaId+'"]').forEach(b=>{b.style.background=(parseInt(b.dataset.opcion)===opcion)?'#c8e6c9':'';});
        });
    });

    function enviarRespuestasEbullicion() {
        const preguntas=[];
        for (let id in respuestasEbullicion) preguntas.push({idPregunta:parseInt(id),opcionSeleccionada:respuestasEbullicion[id]});
        const totalPreguntas=<%= preguntas.size()%>;
        if (preguntas.length<totalPreguntas){document.getElementById('feedbackEbullicion').innerText='Debes responder todas las preguntas.';document.getElementById('feedbackEbullicion').style.color='#f44336';return;}
        document.getElementById('respuestasEbullicionJson').value=JSON.stringify(preguntas);
        document.getElementById('formEbullicion').submit();
    }

    dibujarOlla(100);
</script>
<% }%>