To initialize the algorithm, follow steps:

## 1. run Rails db:migrate
## 2. run Rails db:seed
## 3. run Rails c
## 4. > User.select_and_assign

Courses will be created, and students assigned to their respective courses with the best possible distribution.

Comments: 
  
 - Student and teacher availability is set as two time slots, 1 in the morning and 1 in the afternoon.



















# Tentative Courses

Este es un ejercicio a realizar como parte de la entrevista técnica para la posición de Software Engineer dentro de Nulinga. 

Queremos que te luzcas, que apliques todos tus conocimientos y creatividad. 

Lo importante del ejercicio no es la solución si no que nos cuentes cómo llegaste y las decisiones que fuiste tomando. 

Pensá que no programamos para computadoras si no para otras personas.

No hay una única solución a la hora de diseñar, hay trade-offs. Y lo que ganás en una cosa perdés en otra. Que tengas conciencia de esos trade-offs es lo que buscamos. 

## Condiciones iniciales
Se tiene una lista de estudiantes los cuales cada uno tiene asignado:

* Una modalidad, el cuál puede ser Grupal o Individual
* Un nivel, el cuál puede ser Beginner, Pre-Intermediate, Intermediate, Upper-Intermediate y Advanced
* Una lista de horarios que podrían tomar un curso. Los cuales van de Lunes a Viernes de 9 a 19 hs. 
  * Ejemplo: 
  * Lunes 17:00
  * Miércoles 9:00
  * Jueves 15:00

Se tiene una lista de docentes los cuales tienen: 

* Una lista de horarios de disponibilidad para tomar cursos. Los cuales van de Lunes a Viernes de 9 a 19 hs. 
  * Ejemplo: 
  * Lunes 17:00
  * Miércoles 9:00
  * Jueves 15:00

## Problema

Se desea que se obtener una lista de cursos posibles. 
El curso posible tiene qu tener: 
  
* Un docente.
* Un nivel. 
* Un horario (día y hora)
* Una lista de inscriptos.

Las condiciones para asignar curso posible son las siguientes: 

* Los cursos tienen que respetar el horario que el docente tiene disponible.
* Los cursos tienen que respetar el horario disponible de los estudiantes.
* Todos los inscriptos en el curso tienen que tener el mismo nivel.
* Los cursos grupales pueden contener hasta 6 inscriptos. 
* Los cursos individuales sólo pueden contener 1 inscripto.
* Todos los inscriptos tienen que la misma modalidad. Ej. Si un estudiante eligió modalidad individual no se los puede inscribir en curso grupal.

Estas condiciones pueden ir sufriendo modificaciones con el tiempo. 

## Bonus

Esto no es necesario como requisito para cumplir con el ejercicio pero si lo resolviste rápido, podés pensar como incorporar estos nice to have.

Estaría bueno:

* Tener una lista de los estudiantes que no pudieron ser asignados porque no pudieron cumplir alguna de las condiciones.
* Que al agrupar el curso grupal y hacer el match de horarios pueda matchear también los que difieren en 1 hora o X horas configurable.
  * Ejemplo:
  * Jose Montoto es Beginner y uno de sus horarios diponibles es Jueves 15:00
  * Elena Nito es Beginner y uno de sus horarios disponibles es Jueves 16:00
  * Esteban Quito es Beginner y uno de sus horarios disponibles es Jueves 14:00 
  * Si configuro una diferencia máxima de 1 hora. Espero que se arme un curso tentativo para los 3 inscriptos el Jueves a las 15:00 y marcar las inscripciones de Elena y Esteban que necesitan confirmación de hora.


## Que se espera

* Esperamos que el diseño que plantees sea con modelado en objetos.
* Esperamos que el código lo programes en inglés. 
* Esperamos que puedas contar las decisiones que tomaste y por qué.
* Se espera que el código y el diseño pueda ser entendido por otra persona.
* Tener acceptances tests de los requerimientos. 

## Observaciones

* Se puede usar el lenguaje que desees.
* Intentá hacerlo con TDD
* No es necesario implementar persistencia ni interfaz de usuario. Alcanza con los tests para verificar que la funcionalidad está correctamente implementada
* No es necesario usar ningún framework. 

## ¿Cómo entregarlo?

Forkeá el repositorio y trabajá sobre el mismo. 

## ¡Tengo dudas!

Cualquier duda que tengas podés escribir un issue y te respondemos. También nos sirve para ir mejorando la consigna para hacerla más clara. 