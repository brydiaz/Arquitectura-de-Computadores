;SimpleAlgebra by Bryan Díaz, Luis Chavarría, Josue Gutierrez
;II Tarea Programada por el profesor Eduardo Cannesa.
;Arquitectura de Computadores, ITCR, II Semestre 2020

;????????????????????????????????????????????????????????????????????????
;FUNCIONALIDAD GENERAL
;Este programa tiene una peculiaridad recibe un string
;por ejemplo 2x+1+y, x=2, y=4 y guarda las variables
;en variables y manda a noIngExpresion el resultado de la sustitucinN
;quedando así 2*2+1+4 en noIngExpresion luego mulExpresion procederá a
;hacer las muls y divsy quedará así en mulExpresion: 4+1+4,
;luego en plusExpresion generará las sumas y restas quedando así en resultExpresion
;9, en este da el resultado
;????????????????????????????????????????????????????????????????????????

;Unica biblioteca usada, propiedad del grupo, dentro su correspondiente
;documentacion
%include "theCompleteBasicOperations.asm"

;Seccion de datos inicializados
section .data

  firstMessage db "Bienvenido, por favor inserte la expresón matematica",0xA, 0
  warning db "Recuerda, que en la division ninguno de los valores pueden ser 0",0xA, 0
  zeroDivision db "ERROR FATAL, la division por cero tiende a infinito", 0xA, 0
  menos db "-",0
  exit db "Gracias por usar!", 0
  resultMessage db "El resultado es: ", 0xA, 0

;Seccion de datos sin inicializar (Tamaño solicitado 1024)
section .bss

  expresion resb 1024
  noIngExpresion resb 1024
  divExpresion resb 1024
  mulExpresion resb 1024
  variables resb 1024

  num1 resb 20
  num2 resb 20
  result resb 70
  DivsInOrder resb 2048
  MulsInOrder resb 2048
  sumsAndRest


  resulta db 5

;Seccion de codigo, como tal el flujo principal del programa

;X= corresponde a requisitos previos de funciones
;Y= macros que corresponden a la biblioteca
section .text

  global _start

_start:
  print nwLn
  print nwLn
  print firstMessage;Y
  input expresion, 2021;Y
  print nwLn
  mov r8, expresion;X
  mov rcx,0;X
  call getVariables
  mov r8, expresion;X
  mov rcx, 0;X
  mov r9,0;X
  call getNewExpresion
  mov r8, noIngExpresion;X
  mov rcx, 0;X
  mov r9,0;X
  mov r10, 0
  mov r13, 0
  call makeMuls
  cGRegisters
  mov r9, 0
  mov r10, 0
  mov rcx, 0
  call getExpresionWMuls
  cRegisters
  mov r8, mulExpresion
  mov rcx,0
  mov r9,0
  call makeDivs
  cGRegisters
  mov r9, 0
  mov r10, 0
  mov rcx, 0
  call getExpresionWDivs
  cRegisters
  mov r8, divExpresion
  mov rcx, 0
  mov r9, 0
  mov r12, 0
  mov r13, 0
  call changeFormatToSum
  mov r8, sumsAndRest
  mov rcx, 0
  mov r9, 0
  mov r12, 0
  call makeSum
  cGRegisters
  itoa r13, 10, result
  print resultMessage
  print result
  cleanEtiquete num1, 20
  print nwLn
  print nwLn
  print exit
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
;en noIngExpresion una cadena de texto sin ingcognitas

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
  mov byte[noIngExpresion+r9],bl
  inc r9
  inc rcx
  jmp  getNewExpresion

;Si resulta ser una letra, se custiona si esta es una ingcognita de
;multiplicacion normal (2*x)o 2x para saber como traduir correctamente
;una vez hecho esto lo añade a noIngExpresion y redirije
letter:
  dec rcx
  cmp byte[r8+rcx], 0x30
  jl nexti

  inc rcx
  mov byte[noIngExpresion+r9],0x2A
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
  mov byte[noIngExpresion+r9],0xA
  inc r9
  mov byte[noIngExpresion+r9],0

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
  mov byte[noIngExpresion+r9],al
  inc r12
  inc r9
  jmp startSustitution
endSustitution:
;Al llegar acá, resolvio la ingcognita y continua normalmente
  ret
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;///////////////////////////////////////////////////////////////////////

makeDivs:

  cmp byte[r8+rcx], 0x2F
  jz makeDiv

  cmp byte[r8+rcx], 0xA
  jz endMakeDivs;Acá Acaba mandar a ret

  inc rcx
  jmp makeDivs

makeDiv:
  dec rcx

makeDivAux:
  cmp rcx,0
  jz startReadINumberDivAux

  cmp byte[r8+rcx], 0x30
  jl startReadINumberDivI

  dec rcx
  jmp makeDivAux


startReadINumberDivI:
  inc rcx
startReadINumberDivAux:

  cmp byte[r8+rcx], 0x2F
  jz startReadIINumberDiv

  xor rbx, rbx
  mov bl, byte[r8+rcx]
  mov byte[num1+r9], bl
  mov byte[r8+rcx], 0x24
  inc r9
  inc rcx
  jmp startReadINumberDivAux

startReadIINumberDiv:
  mov r9, 0
  mov byte[r8+rcx], 0x26
  inc rcx
startReadIINumberDivAux:
  cmp byte[r8+rcx], 0x30
  jl makeDivNum1AndNum2

  cmp byte[r8+rcx],0
  jz makeDivNum1AndNum2

  mov bl, byte[r8+rcx]
  mov byte[num2+r9], bl
  inc r9
  mov byte[r8+rcx], 0x24
  inc rcx
  jmp startReadIINumberDivAux
makeDivNum1AndNum2:
  push rcx
  atoi num1
  xor r10, r10
  mov r10, rax
  xor rax, rax
  atoi num2
  xor r12, r12
  mov r12, rax
  xor rax, rax
  mov rax, r10
  mov r10, r12
  xor rdx, rdx
  cmp r10, 0
  jz fatalErrorInDivs
  idiv r10
  cleanEtiquete num1, 20
  cleanEtiquete num2, 20
  mov r10, rax
  xor rax, rax
  xor r12, r12
  itoa r10, 10, result
  mov r10, 0
  mov r12, 0
  call addToResults
  cleanEtiquete result, 20
  pop rcx
  mov r9, 0
  jmp makeDivs

addToResults:
  cmp byte[result+r12], 0
  jz resultAdd
  mov bl,byte[result+r12]
  mov byte[DivsInOrder+r13], bl
  inc r12
  inc r13
  jmp addToResults

resultAdd:
  mov bl, ","
  mov byte[DivsInOrder+r13], bl
  inc r13
  ret

endMakeDivs:
  ret


getExpresionWDivs:

  cmp byte[r8+rcx], 0xA
  jz endGetExpresionWDivs

  cmp byte[r8+rcx], 0x24
  jz pass

  cmp byte[r8+rcx], 0x26
  jz itsDiv

  mov bl, byte[r8+rcx]
  mov byte[divExpresion+r9],bl
  inc r9
  inc rcx
  jmp getExpresionWDivs

pass:

  inc rcx
  jmp getExpresionWDivs

itsDiv:

  cmp byte[DivsInOrder+r10], ","
  jz endToAddTheRD

  mov bl, byte[DivsInOrder+r10]
  mov byte[divExpresion+r9],bl

  inc r9
  inc r10

  jmp itsDiv

endToAddTheRD:
  inc rcx
  inc r10
  jmp getExpresionWDivs

endGetExpresionWDivs:

  inc r9
  mov byte[divExpresion+r9], 0

  ret

fatalErrorInDivs:
  print zeroDivision
  endProgram
;////////////////////////////////////////////////////////////////////////

;************************************************************************

makeMuls:

  cmp byte[r8+rcx], 0x2A
  jz makeMul

  cmp byte[r8+rcx], 0xA
  jz endMakeMul;Acá Acaba mandar a ret

  inc rcx
  jmp makeMuls

makeMul:
  dec rcx

makeMulAux:
  cmp rcx,0
  jz startReadINumber2Aux

  cmp byte[r8+rcx], 0x30
  jl startReadINumber2I

  dec rcx
  jmp makeMulAux


startReadINumber2I:
  inc rcx
startReadINumber2Aux:

  cmp byte[r8+rcx], 0x2A
  jz startReadIINumber2

  xor rbx, rbx
  mov bl, byte[r8+rcx]
  mov byte[num1+r9], bl
  mov byte[r8+rcx], 0x24
  inc r9
  inc rcx
  jmp startReadINumber2Aux

startReadIINumber2:
  mov r9, 0
  mov byte[r8+rcx], 0x26
  inc rcx
startReadIINumber2Aux:


  cmp byte[r8+rcx], 0x30
  jl makeMulNum1AndNum2

  cmp byte[r8+rcx],0
  jz makeMulNum1AndNum2;Acá acaba Mandar a ret

  mov bl, byte[r8+rcx]
  mov byte[num2+r9], bl

  inc r9
  mov byte[r8+rcx], 0x24
  inc rcx
  jmp startReadIINumber2Aux
makeMulNum1AndNum2:
  push rcx
  atoi num1
  xor r10, r10
  mov r10, rax
  xor rax, rax
  atoi num2
  imul r10
  cleanEtiquete num1, 20
  cleanEtiquete num2, 20
  mov r10, rax
  xor rax, rax
  xor r12, r12
  itoa r10, 10, result
  mov r10, 0
  mov r12, 0
  call addToResults2
  cleanEtiquete result, 20
  pop rcx
  mov r9, 0
  jmp makeMuls

addToResults2:
  cmp byte[result+r12], 0
  jz resultAdd2
  mov bl,byte[result+r12]
  mov byte[MulsInOrder+r13], bl
  inc r12
  inc r13
  jmp addToResults2

resultAdd2:
  mov bl, ","
  mov byte[MulsInOrder+r13], bl
  inc r13
  ret

endMakeMul:
  ret

getExpresionWMuls:


  cmp byte[r8+rcx], 0xA
  jz endGetExpresionWMuls

  cmp byte[r8+rcx], 0x24
  jz pass2

  cmp byte[r8+rcx], 0x26
  jz itsMul

  mov bl, byte[r8+rcx]
  mov byte[mulExpresion+r9],bl
  inc r9
  inc rcx
  jmp getExpresionWMuls

pass2:

  inc rcx
  jmp getExpresionWMuls

itsMul:

  cmp byte[MulsInOrder+r10], ","
  jz endToAddTheRM

  mov bl, byte[MulsInOrder+r10]
  mov byte[mulExpresion+r9],bl

  inc r9
  inc r10

  jmp itsMul

endToAddTheRM:
  inc rcx
  inc r10
  jmp getExpresionWMuls

endGetExpresionWMuls:
  inc r9
  mov byte[mulExpresion+r9],0


  ret
;*****************************************************************************

;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

changeFormatToSum:

  cmp byte[r8+rcx], 0
  jz endChangeFormatToSum

  cmp byte[r8+rcx], 0x2B
  jz foundPositive

  cmp byte[r8+rcx], 0x2D
  jz foundNegative

  cmp r9, 0
  jz firstNumber

  mov bl, byte[r8+rcx]
  mov byte[sumsAndRest+r9], bl
  inc r9
  inc rcx
  jmp changeFormatToSum

firstNumber:
  mov byte[sumsAndRest+r9], "+"
  inc r9
  jmp changeFormatToSum

foundPositive:
  mov byte[sumsAndRest+r9], ","
  inc r9
  mov byte[sumsAndRest+r9], "+"
  inc r9
  inc rcx
  jmp changeFormatToSum

foundNegative:
  mov byte[sumsAndRest+r9], ","
  inc r9
  mov byte[sumsAndRest+r9], "-"
  inc r9
  inc rcx
  jmp changeFormatToSum

endChangeFormatToSum:
  ret
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
makeSum:

  cmp byte[r8+rcx], 0
  jz endMakeSum

  cmp byte[r8+rcx], 0x2B
  jz plus

  cmp byte[r8+rcx], 0x2D
  jz less

  inc rcx
  jmp makeSum

plus:
  inc rcx
plusAux:
  cmp byte[r8+rcx], 0
  jz nextDigitToReadPlus

  cmp byte[r8+rcx], ","
  jz nextDigitToReadPlus

  mov bl,byte[r8+rcx]
  mov byte[num1+r9], bl
  inc rcx
  inc r9

  jmp plusAux

less:
    inc rcx
lessAux:
  cmp byte[r8+rcx], 0
  jz nextDigitToReadLess

  cmp byte[r8+rcx], ","
  jz nextDigitToReadLess

  mov bl,byte[r8+rcx]
  mov byte[num1+r9], bl
  inc rcx
  inc r9

  jmp lessAux

nextDigitToReadPlus:
  inc rcx
  xor rax, rax
  atoi num1
  add r13, rax
  mov r9,0
  cleanEtiquete num1, 20
  jmp makeSum

nextDigitToReadLess:
  inc rcx
  xor rax, rax
  atoi num1
  neg rax
  add r13, rax
  mov r9,0
  cleanEtiquete num1, 20
  jmp makeSum

endMakeSum:
  cmp r13, 0
  jl itsANegativeResult
endR:
  ret

itsANegativeResult
  neg r13
  cGRegister
  print menos
  cGRegisters
  jmp endR
