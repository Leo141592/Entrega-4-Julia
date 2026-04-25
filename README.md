# 🎬 Sistema de Recomendación de Películas en Julia

## 📌 Descripción

Este proyecto implementa un sistema de recomendación de películas utilizando el lenguaje **Julia**. El sistema permite a un usuario ingresar sus películas favoritas y, a partir de esa información, genera recomendaciones personalizadas basadas en similitud con otros usuarios.

El enfoque utilizado pertenece al área de **filtrado colaborativo**, una técnica común en plataformas como Netflix o Spotify.

---

## 🧠 Objetivo

Desarrollar un sistema que:

* Reciba preferencias del usuario
* Compare esas preferencias con otros usuarios
* Recomiende nuevas películas que podrían gustarle

---

## ⚙️ Tecnologías utilizadas

* Lenguaje: **Julia**
* Librerías:

  * `Statistics` (para cálculos matemáticos básicos)

---

## 🧩 Estructuras de datos utilizadas

Este proyecto hace uso de varias estructuras fundamentales:

* `Dict{String, Dict{String, Float64}}`
  Representa los usuarios y sus calificaciones de películas.

* `Set`
  Para manejar películas ya vistas por el usuario.

* `Array`
  Para ordenar y procesar recomendaciones.

---

## 🔍 Algoritmo utilizado

El sistema utiliza **similitud del coseno** para medir qué tan parecidos son dos usuarios.

### Pasos del algoritmo:

1. El usuario ingresa sus 3 películas favoritas
2. Se asigna un valor alto (rating = 5) a esas películas
3. Se calcula la similitud con otros usuarios
4. Se identifican películas no vistas
5. Se calcula un puntaje ponderado
6. Se ordenan las recomendaciones

---

## ▶️ Cómo ejecutar el programa

1. Abrir Julia
2. Ejecutar el archivo `.jl`
3. Ingresar 3 películas cuando el programa lo solicite

Ejemplo:

```
🎬 Escribe tus 3 películas favoritas:
Película 1: Matrix
Película 2: Inception
Película 3: Interstellar
```

---

## 📊 Ejemplo de salida

```
🔥 Recomendaciones para ti:
👉 Avatar (score: 4.6)
👉 Gladiator (score: 4.2)
```

---

## 🚀 Características principales

* Sistema interactivo
* Recomendaciones personalizadas
* Uso de estructuras de datos avanzadas
* Implementación de algoritmo de similitud

---

## ⚠️ Limitaciones

* Base de datos pequeña (pocos usuarios)
* No utiliza datos reales
* No considera factores como género o popularidad

---

## 🔧 Posibles mejoras

* Integrar más usuarios y películas
* Usar datos reales
* Implementar interfaz gráfica
* Aplicar otros algoritmos de recomendación
* Guardar historial de usuarios

---

## 👨‍💻 Autor

Proyecto desarrollado como parte del curso de **Algoritmos y Estructuras de Datos**.

---

## 📌 Conclusión

Este proyecto demuestra cómo aplicar estructuras de datos y algoritmos matemáticos para resolver un problema real: la recomendación de contenido. Además, evidencia el potencial de Julia para desarrollar soluciones eficientes en análisis de datos.

---
