;Esta biblioteca esta totalmente diseñada por el equipo de trabajo
;que trabajo en el desarrollo de este proyecto


;Esta macro recibe 7 parametros

;PrimerTexto, el indice (DEBE SER UN NUMERO),contador de letras(DEBE SER UN NUMERO)
;contador de letras convertidas(DEBE SER UN NUMERO), contador de palabras convertidas(DEBE SER UN NUMERO
;y el segundo texto para comparar.
;Entonces en ese orden son asociadas a un numero 1,2,3,4,5,6,7
;La forma en que funciona la funcion es muy sencilla.
;Compara si llego al final, sino lo ha hecho entonces prosigue
;Compara si hay un espacio, en caso de haber significa que hay una palabra por lo tanto la suma
;Compara si las dos letras en las mismas posiciones NO son iguales, entonces es una letra convertidas
;En caso de ser igual cuenta la letra y continua hasta encontrar una excepcion
;NOTA: EN LOS REGISTROS QUE SE PASARON QUEDARAN LOS RESULTADOS DE CADA UNA DE LOS TOTALES
;NOTA II: DEBIDO A SU COMPLEJIDAD SE SEPARO EL CONTAR LAS PALABRAS QUE FUERON CAMBIADAS

;PARA EL USO DEL PROGRAMA TRADUCTOR EN LA TAREA PROGRAMA #1 DEL PROFESOR CANESSA
;EL EQUIPO DE TRABAJO DECIDÍO USAR LOS REGISTROS ASÍ
;R8 el indice, R9 contador de letras, R10 contador de palabras, R12 contador de letras convertidas
;R13 PALABRAS CONVERTIDAS


%macro comparador 7

%%inicio:

  mov al, byte[%1+%2]
  mov bl, byte[%7+%2]

  cmp al, 0
  jz %%endProcess

  cmp al, 0x20
  jz %%nuevaPalabra

  cmp al, bl
  jnz %%letraConvertida

  inc %2
  inc %3
  jmp %%inicio

%%nuevaPalabra:
  inc %4
  inc %2
  jmp %%inicio

%%letraConvertida:

  inc %5
  inc %2
  jmp %%inicio

%%endProcess:

  sub %2, %4
  mov %3, %2
  inc %4
  dec %3


%endmacro


;Ya mencionado, este codigo posee un poco más de complejidad
;recibe 4 parametros: texto, indice, palabras convertidas, texto original
;solo texto original y texto son strings lo demás son numeros.
;basicamente, la funcion compara si llego al final, en caso de no hacerlo
;pregunta si las letras no son iguales, sí lo son, entonces solo se mueve,
;pero en caso de no serlo, sumara uno a la cantidad de letras convertidas
;y se movera hasta encontrar el siguiente espacio, ingnorando las demás letras
;y así hasta terminar la palabra

%macro contarPalabrasDistintas 4
%%inicioCiclo:
  mov al, byte[%1+%2]
  mov bl, byte[%4+%2]

  cmp al, 0
  jz %%endLoop

  cmp al, bl
  jnz %%palabraCambiada

  inc %2
  jmp %%inicioCiclo

%%palabraCambiada:
  inc %3
%%proceso:

  cmp al, 0
  jz %%endLoop

  inc %2
  mov al, byte[%1+%2]
  mov bl, byte[%4+%2]

  cmp al, 0
  jz %%endLoop

  cmp al, 0x20
  jnz %%proceso

  inc %2
  jmp %%inicioCiclo

%%endLoop:

%endmacro
