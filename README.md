# 🍳 Chef Molecular
![Versión](https://img.shields.io/badge/versión-1.0-orange)
![Java](https://img.shields.io/badge/Java-25.0.1-red)
![NetBeans](https://img.shields.io/badge/NetBeans-28-blue)
![Tomcat](https://img.shields.io/badge/Tomcat-10.1.54-green)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Licencia](https://img.shields.io/badge/licencia-MIT-green)

**Plataforma educativa interactiva** para la enseñanza de química molecular a través de la cocina molecular.

---

## 📖 Descripción del Proyecto

Chef Molecular es una aplicación web educativa que enseña conceptos fundamentales de **química molecular** (fuerzas intermoleculares, estados de la materia, propiedades de líquidos, etc.) mediante un enfoque lúdico basado en la **cocina molecular**.

Los estudiantes aprenden mientras cocinan virtualmente, desbloquean recetas, ganan estrellas Michelín y suben posiciones en el ranking de chefs.

### 🎯 Objetivo Pedagógico
- Facilitar el aprendizaje de química a través de **simulaciones interactivas**
- Motivar a los estudiantes con un sistema de **gamificación** (rangos, insignias, recetas desbloqueables)
- Ofrecer **feedback inmediato** mediante quizzes y experimentos virtuales
- Relacionar conceptos abstractos con **aplicaciones culinarias reales**

### ✨ Características Principales

| Característica | Descripción |
|----------------|-------------|
| 🧪 **6 Escenarios Interactivos** | Dispersión de London, dipolo-dipolo, puentes de hidrógeno, estados de la materia, propiedades de líquidos, presión de vapor |
| 👨‍🍳 **Sistema de Progresión** | Completa escenarios, obtén estrellas y desbloquea recetas reales |
| 🎮 **Simulaciones Moleculares** | Animaciones en canvas que muestran interacciones polares/no polares |
| 📚 **Libro de Recetas** | Cada receta desbloqueada incluye ingredientes y preparación |
| 🏆 **Ranking de Chefs** | Competencia amistosa con puntuación por estrellas Michelín |
| 🌓 **Modo Noche/Día** | Interfaz adaptable para mejor experiencia de usuario |
| 🔐 **Sistema de Login** | Registro y autenticación de usuarios |

---

## 🛠️ Tecnologías Utilizadas

| Componente | Versión | Propósito |
|------------|---------|-----------|
| **Java JDK** | 25.0.1 | Lógica de negocio, servlets |
| **Apache NetBeans** | 28 | Entorno de desarrollo integrado (IDE) |
| **Apache Tomcat** | 10.1.54 | Servidor de aplicaciones (Jakarta EE 10) |
| **MySQL Server** | 8.0 | Base de datos relacional |
| **MySQL Connector/J** | 8.0.31 | Driver JDBC para conexión a MySQL |
| **org.json** | 20120521 | Procesamiento y manipulación de datos JSON |
| **HTML5/CSS3** | - | Interfaz de usuario y estilos |
| **JavaScript (ES6)** | - | Animaciones e interactividad |

---

## 📋 Requisitos Previos

Antes de instalar, asegúrate de tener:

- ✅ **Java JDK 25.0.1** o superior ([Descargar](https://adoptium.net/))
- ✅ **Apache NetBeans 28** o superior ([Descargar](https://netbeans.apache.org/))
- ✅ **Apache Tomcat 10.1.54** o superior ([Descargar](https://tomcat.apache.org/download-10.cgi))
- ✅ **MySQL Server 8.0** o superior ([Descargar](https://dev.mysql.com/downloads/mysql/8.0.html))
- ✅ **MySQL Connector/J 8.0.31** ([Descargar](https://downloads.mysql.com/archives/c-j/))
- ✅ **org.json-20120521.jar** ([Descargar desde Maven Central](https://search.maven.org/artifact/org.json/json/20120521/jar))
- ✅ **Git** (opcional, para clonar) ([Descargar](https://git-scm.com/))

---

## 🚀 Instalación Paso a Paso

### 1️⃣ Clonar o descargar el proyecto

```bash
# Clonar con Git
git clone https://github.com/TU_USUARIO/chef-molecular.git

# O descargar el ZIP desde GitHub y extraer
cd chef-molecular
```

### 2️⃣ Configurar la base de datos MySQL

```sql
-- Crear la base de datos
CREATE DATABASE chef_molecular CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Crear usuario (opcional)
CREATE USER 'chef_user'@'localhost' IDENTIFIED BY 'tu_contraseña';
GRANT ALL PRIVILEGES ON chef_molecular.* TO 'chef_user'@'localhost';
FLUSH PRIVILEGES;

-- Importar el esquema
USE chef_molecular;
SOURCE ruta/al/archivo/chef_molecular.sql;
```

### 3️⃣ Agregar las dependencias (JARs) al proyecto

El proyecto requiere los siguientes archivos `.jar` en la carpeta `WEB-INF/lib/`:

```
WEB-INF/
└── lib/
    ├── mysql-connector-j-8.0.31.jar
    └── org.json-20120521.jar          ← ¡Requerido!
```

**En NetBeans:**
1. Clic derecho sobre el proyecto → **Properties**
2. Ir a **Libraries** → **Compile** → **Add JAR/Folder**
3. Seleccionar `org.json-20120521.jar`
4. Hacer clic en **OK** y **Close**

> 💡 **Descarga directa del JAR:**  
> [org.json-20120521.jar — Maven Central](https://search.maven.org/remotecontent?filepath=org/json/json/20120521/json-20120521.jar)

### 4️⃣ Configurar la conexión a la base de datos

Edita el archivo de configuración de conexión (por ejemplo, `src/java/util/ConexionDB.java` o similar):

```java
private static final String URL  = "jdbc:mysql://localhost:3306/chef_molecular";
private static final String USER = "chef_user";       // tu usuario MySQL
private static final String PASS = "tu_contraseña";   // tu contraseña MySQL
```

### 5️⃣ Configurar Tomcat en NetBeans

1. Ir a **Tools** → **Servers** → **Add Server**
2. Seleccionar **Apache Tomcat or TomEE**
3. Indicar la ruta de instalación de Tomcat 10.1.54
4. Asignar usuario y contraseña de administrador

### 6️⃣ Ejecutar el proyecto

1. Clic derecho sobre el proyecto → **Clean and Build**
2. Clic derecho → **Run** (o `F6`)
3. El navegador se abrirá automáticamente en:

```
http://localhost:8080/ChefMolecular/
```

---

## 📦 Dependencias del Proyecto

### JARs requeridos en `WEB-INF/lib/`

| Archivo JAR | Versión | Función | Descarga |
|-------------|---------|---------|----------|
| `mysql-connector-j-8.0.31.jar` | 8.0.31 | Conexión JDBC a MySQL | [Descargar](https://downloads.mysql.com/archives/c-j/) |
| `org.json-20120521.jar` | 20120521 | Parseo y generación de JSON | [Descargar](https://search.maven.org/artifact/org.json/json/20120521/jar) |

### ¿Por qué `org.json-20120521`?

La librería **org.json** es utilizada en los servlets del proyecto para:
- Construir respuestas JSON desde el servidor (`JSONObject`, `JSONArray`)
- Parsear datos JSON enviados desde el cliente (JavaScript → Servlet)
- Serializar objetos Java para las APIs internas del sistema de gamificación

```java
// Ejemplo de uso en un servlet
import org.json.JSONObject;
import org.json.JSONArray;

JSONObject respuesta = new JSONObject();
respuesta.put("estrellas", 3);
respuesta.put("receta", "Esferificación Básica");
respuesta.put("rango", "Chef Sous");

out.print(respuesta.toString());
```

---

## 📁 Estructura del Proyecto

```
ChefMolecular/
├── src/
│   └── java/
│       ├── controlador/       # Servlets (lógica HTTP)
│       ├── modelo/            # Clases de entidad (Usuario, Receta, etc.)
│       └── util/              # Conexión DB, helpers JSON
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   └── lib/
│   │       ├── mysql-connector-j-8.0.31.jar
│   │       └── org.json-20120521.jar   ← Aquí va el JAR
│   ├── css/
│   ├── js/
│   ├── img/
│   └── *.html / *.jsp
├── README.md
└── chef_molecular.sql         # Script de base de datos
```

---

## 🐛 Solución de Problemas Comunes

### ❌ `ClassNotFoundException: org.json.JSONObject`
**Causa:** El JAR `org.json-20120521.jar` no está en `WEB-INF/lib/` o no fue agregado al classpath.  
**Solución:** Verificar que el archivo está físicamente en `web/WEB-INF/lib/` y que fue añadido en **Properties → Libraries** de NetBeans.

### ❌ `Communications link failure` (MySQL)
**Causa:** MySQL no está corriendo o las credenciales son incorrectas.  
**Solución:** Iniciar el servicio MySQL y revisar los datos en `ConexionDB.java`.

### ❌ Error 404 al ejecutar
**Causa:** Tomcat no desplegó correctamente la aplicación.  
**Solución:** Hacer **Clean and Build** completo y revisar la consola de NetBeans.

---

## 👥 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Haz un **fork** del repositorio
2. Crea una rama: `git checkout -b feature/nueva-funcionalidad`
3. Realiza tus cambios y haz commit: `git commit -m "Agrega nueva funcionalidad"`
4. Envía un pull request

---

## 📄 Licencia

Este proyecto está bajo la **Licencia MIT**. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## 🙏 Agradecimientos

- [org.json](https://github.com/stleary/JSON-java) — Librería JSON para Java
- [Apache Tomcat](https://tomcat.apache.org/) — Servidor de aplicaciones
- [MySQL](https://www.mysql.com/) — Sistema de gestión de bases de datos

