;SimpleAlgebra by Bryan Díaz, Luis Chavarría, Josue Gutierrez
;II Tarea Programada por el profesor Eduardo Cannesa.
;Arquitectura de Computadores, ITCR, II Semestre 2020

;/////////////////////////////////////////////////////////////////////////
;FUNCIONALIDAD GENERAL
;Este programa tiene una peculiaridad recibe un string
;por ejemplo 2x+1+y, x=2, y=4 y guarda las variables
;en variables y manda a newExpresion el resultado de la sustitucio
;quedando así 2*2+1+4 en newExpresion luego guarda en expresion
;esta nueva expresion, y en newExpresion procederá a hacer las muls y divs
;y quedará así en newExpresion: 4+1+4, entonces manda esto a expresion de nuevo
;luego en newExpresion generará las sumas y restas quedando así en newExpresion
;9, luego lo devuelve a expresion y allí procederá a dar el resultado
;////////////////////////////////////////////////////////////////////////

;Unica biblioteca usada, propiedad del grupo, dentro su correspondiente
;documentacion
%include "theCompleteBasicOperations.asm"

;Seccion de datos inicializados
section .data

  firstMessage db "Bienvenido, por favor inserte la expresón matematica",0xA, 0

;Seccion de datos sin inicializar (Tamaño solicitado 1024)
section .bss

  expresion resb 2021
  newExpresion resb 2021
  variables resb 2021

;Seccion de codigo, como tal el flujo principal del programa

;X= corresponde a requisitos previos de funciones
;Y= macros que corresponden a la biblioteca
section .text

  global _start

_start:

  print firstMessage;Y
  input expresion, 2021;Y
  mov r8, expresion;X
  mov rcx,0;X
  call getVariables
  mov r8, expresion;X
  mov rcx, 0;X
  mov r9,0;X
  call getNewExpresion
  endProgram


;Esta funcion se encarga de recorrer el string ingresado
;por terminal, y guarda en variables el resultado, contendrá
;n cantidad de variables donde n es de 0 a 10

;#################################################################

;Se mueve hasta encontrar la coma
getVariables:
  cmp byte[r8+rcx], 0x2C
  jz startRead
  inc rcx
  mov r9,0
  jmp getVariables

;Está en la coma, hay que moverse
startRead:
  inc rcx

;Empieza a leer y guardar en variables todo lo que haya
startReadAux:
  cmp byte[r8+rcx], 0xA
  jz endP
  mov al, byte[r8+rcx]
  mov byte[variables+r9], al
  inc rcx
  inc r9
  jmp startReadAux

endP:
  mov byte[variables+r9],0xA
  inc r9
  mov byte[variables+r9],0
  ret
;####################################################################

;Esta funcion se encarga de sustuir en newExpresion, las ingcognitas
;que posea expresion, con su respectivo valor en variables, dejando así
;en newExpresion una cadena de texto sin ingcognitas

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

;Se encarga de ir por cada caracter, preguntando si es un
;operador, o bien una ingcognita, si es un numero, solo añade
;este numero al newExpresion, si es un operando, entonces redirije
getNewExpresion:
  cmp byte[r8+rcx], 0x2C
  jz endGetNewExpresion

  cmp byte[r8+rcx], 0x39
  jg letter

  mov bl,byte[r8+rcx]
  mov byte[newExpresion+r9],bl
  inc r9
  inc rcx
  jmp  getNewExpresion

;Si resulta ser una letra, se custiona si esta es una ingcognita de
;multiplicacion normal (2*x)o 2x para saber como traduir correctamente
;una vez hecho esto lo añade a newExpresion y redirije
letter:
  dec rcx
  cmp byte[r8+rcx], 0x31
  jl nexti

  inc rcx
  mov byte[newExpresion+r9],0x2A
  inc r9
  jmp n

nexti:
  inc rcx
n:
  xor rdx, rdx
  xor rax, rax
  mov dl, byte[r8+rcx]
  inc rcx
  call getValor
  jmp getNewExpresion

;Una vez acá añade un nwLn al final de la letra, y un 0
endGetNewExpresion:
  mov byte[newExpresion+r9],0xA
  inc r9
  mov byte[newExpresion+r9],0

  ret

;Guarda las variables en un resgistro para no perderlas
;e inicia un contador
getValor:

  mov r10, variables
  mov r12, 0
;Se mueve por string hasta encontrar la variable correspondiente
bucle:
  cmp dl, byte[r10+r12]
  jz goalValor
  inc r12
  jmp bucle
;Una vez lo hace, sabe que viene un = por lo tanto se mueve dos veces
;para empezar a leer el numero
goalValor:
  inc r12
  inc r12

startSustitution:
  mov al, byte[r10+r12]
;Verifica si es , o nwLn para saber si termino
  cmp al, 0xA
  jz endSustitution
  cmp al, 0x2C
  jz endSustitution
;Va añadiendo el numero hasta terminar
  mov byte[newExpresion+r9],al
  inc r12
  inc r9
  jmp startSustitution
endSustitution:
;Al llegar acá, resolvio la ingcognita y continua normalmente
  ret
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
