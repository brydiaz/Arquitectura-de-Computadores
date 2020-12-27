;SimpleAlgebra by Bryan Díaz, Luis Chavarría, Josue Gutierrez
;II Tarea Programada por el profesor Eduardo Cannesa.
;Arquitectura de Computadores, ITCR, II Semestre 2020

;????????????????????????????????????????????????????????????????????????
;FUNCIONALIDAD GENERAL
;Este programa tiene una peculiaridad recibe un string
;por ejemplo 2x+1+y, x=2, y=4 y guarda las variables
;en variables y manda a noIngExpresion el resultado de la sustitucion
;quedando así 2*2+1+4 en noIngExpresion luego mulExpresion procederá a
;hacer las muls luego las divisiones y por ultimo las sumas y restas
;????????????????????????????????????????????????????????????????????????

;Unica biblioteca usada, propiedad del grupo, dentro,  su correspondiente
;documentacion
%include "theCompleteBasicOperations.asm"

;Seccion de datos inicializados
section .data

  firstMessage db "Bienvenido, por favor inserte la expresón matematica",0xA, 0
  advice db "Esquema de ejemplo: xy+y/x, x=n, y=p", 0xA, 0
  advice2 db "Con x i y pertenecientes a numeros reales positivos", 0xA, 0

  warning db "Recuerda, que en la division ninguno de los valores pueden ser 0",0xA, 0
  zeroDivision db "ERROR FATAL, la division por cero tiende a infinito", 0xA, 0
  menos db "-",0
  exit db "Gracias por usar!", 0
  resultMessage db "El resultado es: ", 0xA, 0
  proceso db "Proceso: ", 0xA, 0
  aditional db "Adicional, mostramos las 3, estructuras auxiliares: ",0xA, 0
  muls db "Representa los productos en orden realizados: ", 0xA, 0
  divs db "Representa las divisiones en orden realizados: ", 0xA,0
  sumsandrest db "Representa los numeros a sumar en orden leídos: ", 0xA,0
  error01 db "Error01: ERROR EN VARIABLES", 0xA,0
  error02 db "Error02: ERROR NO EXISTE CIERTA VARIABLE EN PROGRAMA", 0xA, 0
  error03 db "Error03: ERROR EN EL INGRESO DE LA EXPRESION", 0xA, 0
  error04 db "Error04: ERROR NUMERO MAYOR A 64 BITS", 0xA, 0
;Seccion de datos sin inicializar (Tamaño solicitado 1024)
section .bss

  expresion resb 1024
  noIngExpresion resb 1024
  divExpresion resb 1024
  mulExpresion resb 1024
  variables resb 1024
  variablesForValidation resb 1024
  characterToCompare resb 2

  num1 resb 20
  num2 resb 20

  result resb 2048
  DivsInOrder resb 2048
  MulsInOrder resb 2048
  sumsAndRest resb 2048


  resulta resb 5


;Seccion de codigo, como tal el flujo principal del programa

;X= corresponde a requisitos previos de funciones
;Y= macros que corresponden a la biblioteca
;Z= llamada a las distintas funciones
section .text

  global _start

_start:

;OBTENCION DEL DATO
  print nwLn;Y
  print nwLn;Y
  print firstMessage;Y
  print advice
  print advice2
  print nwLn
  input expresion, 2021;Y

;VALIDACIONES
  mov rcx,0
  mov r9,0
  call variablesValidations
  mov rcx,0
  mov r9,0
  call allTheVariablesOfTheExpresion
  mov rcx,0
  call analizeExpresion

;INICIO DE PROGRAMA
  mov rcx,0
  mov r10,0
  print nwLn;Y
  print proceso;Y
  mov r8, expresion;X
  print expresion;Y
  mov rcx,0;X
  call getVariables;Z
  mov r8, expresion;X
  mov rcx, 0;X
  mov r9,0;X
  call getNewExpresion;Z
  mov r8, noIngExpresion;X
  print noIngExpresion;Y
  mov rcx, 0;X
  mov r9,0;X
  mov r10, 0;x
  mov r13, 0;x
  call makeMuls;Z
  cGRegisters;Y
  print r8;Y
  mov r9, 0;x
  mov r10, 0;x
  mov rcx, 0;x
  call getExpresionWMuls;Z
  cRegisters;Y
  mov r8, mulExpresion;x
  print r8;Y
  print nwLn;Y
  mov rcx,0;x
  mov r9,0;x
  call makeDivs;Z
  cGRegisters;Y
  print r8
  mov r9, 0;x
  mov r10, 0;x
  mov rcx, 0;x
  call getExpresionWDivs;Z
  cRegisters;Y
  mov r8, divExpresion;x
  print nwLn;Y
  print r8;x
  print nwLn;Y
  mov rcx, 0;x
  mov r9, 0;x
  mov r12, 0;x
  mov r13, 0;x
  call changeFormatToSum;Z
  mov r8, sumsAndRest;x
  mov rcx, 0;x
  mov r9, 0;x
  mov r12, 0;x
  call makeSum;Z
  cGRegisters;Y
  itoa r13, 10, result
  print resultMessage;Y
  print result;Y
  cleanEtiquete num1, 20;x

;ESTO SON LAS IMPRESIONES FINALES DEL PROGRAMAppppppppppppppppppppppppppppppppp
  print nwLn
  print nwLn
  print aditional
  print nwLn
  print muls
  print MulsInOrder
  print nwLn
  print divs
  print DivsInOrder
  print nwLn
  print nwLn
  print sumsandrest
  print sumsAndRest
  print nwLn
  print nwLn
  print exit
  print nwLn
;ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp

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

;Funcion de division que se divide en dos grandes partes
;la primera es ir moviendose por el string hasta encontrar
;el simbolo de la division sino lo encuentra entonces este iría
;directo al final, si lo encuentra procede a devolverse obteniendo
;el primer numero y simultaneo colocando $ en las posiciones que ya leyó
;cuando llega al signo de la division pone un & y lee hasta encotrar otro
;delimitador o bien el final de linea. La parte 2 está explicada en su respectiva
;parte dentro del codigo

;///////////////////////////////////////////////////////////////////////

;Busca el signo o el final
makeDivs:

  cmp byte[r8+rcx], 0x2F
  jz makeDiv

  cmp byte[r8+rcx], 0xA
  jz endMakeDivs;Acá Acaba mandar a ret

  inc rcx
  jmp makeDivs

;Division encontrada, procede a devolverse buscando el operador anterior
;O principio de linea
makeDiv:
  dec rcx

makeDivAux:
  cmp rcx,0
  jz startReadINumberDivAux

  cmp byte[r8+rcx], 0x30
  jl startReadINumberDivI

  dec rcx
  jmp makeDivAux

;Procede a avanzar buscando el operador siguiente
;O el final de linea guardando el primer numero en num1
;y poniendo un $ en las posiciones ya leídas
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

;Pone el ampersand en la delimitacion de la division
startReadIINumberDiv:
  mov r9, 0
  mov byte[r8+rcx], 0x26
  inc rcx
;Procede a avanzar buscando el operador siguiente
;O el final de linea guardando el segundo numero en num2
;y poniendo un $ en las posiciones ya leídas
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

;II PARTE de la funcion, en esta lo que hará es realizar la divison de ambos
;num1 y num2, y validando que el num2, no sea 0, y guardara los resultados
;dentro de una variable separandolos por coma, para despues al final
;solo sustituirlos en la variable inicial

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

;En resultado, esta despues de hacer el itoa
;el resultado de la divsion en ascii, lo que hace
;es ir añadiendo este resultado a DivsInOrder
;que contiene todas las divisiones hechas en orden


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

;USE DE EJEMPLO=2x+24/12+2
;Esta funcion lo que hace es jugar con tres cadenas de texto
;una donde esta el string con todas las operaciones pero donde
;Haya divisiones habrá algo así 2x+$$&$$+2 otro donde este
;las divisiones en orden en ese ejemplo sería 2,
;y el tercer donde irá construyendo el string que ya no posee divisiones
;que enviará a el siguiente tramiento
;añadir que si no es un $ o & en el string final estará añadiendo los otros
;caracteres como 2x o bien +2


;Busca si llego al final del string, si es un $ solo ingnora
;y si es & pone el resultado que haya en orden en el string de DivsInOrder
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


;Va añadiendo al resultado (divExpresion) hasta encontrar la coma
;que significa que ya sigue otra divsion o bien el final
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
;Pone al final un 0 para imprimir exitosamente
endGetExpresionWDivs:

  inc r9
  mov byte[divExpresion+r9], 0

  ret

;Si topa un 0 en el divisor, termina el programa
fatalErrorInDivs:
  print zeroDivision
  endProgram
;////////////////////////////////////////////////////////////////////////

;ESTA FUNCIONS SE COMPORTA IGUAL A LA DE DIVISION, SOLO ES DE LEER
;CON DETENIMIENTO LA DE DIVSION Y SE ENTENDERÁ LO MISMO, DIFIERE EN QUE
;EN LUGAR DE DIVIDIR, MULTIPLICA, Y NO IMPORTA SI ALGUNO DE SUS PARAMETROS
;ES O

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

;Bien esta funcion funciona de la siguiente manera, va leyendo
;las sumas y restas para saber si un numero es positivo o negativo
;y los va guardando en una variable auxiliar(sumsAndRest) entonces
;la primera lectura captura esos valores y va guardando en su auxiliar
;los datos de la siguiente forma +2x, -2y, +2, luego irá obteniendo esos
;valores  y si es un menos, lo niega y lo suma a una variable resultado,
;sino solo lo suma(cabe decir que irá convirtiendo el ascii a numero antes de
;sumar), y luego al final valida si el numero es negativo o positivo, si es
;negativo lo vuelve a negar y imprime un - y luego el numero de ser positivo
;solo lo imprime


;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

;Busca un menos o más, pero si es el primer numero, pues lo irá guardando
;con un + por delante

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

;Guarda el primer numero con un +
firstNumber:
  mov byte[sumsAndRest+r9], "+"
  inc r9
  jmp changeFormatToSum

;Pone una coma, y luego su signo
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

;Irá obteniendo los
;valores  y si es un menos, lo niega y lo suma a una variable resultado,
;sino solo lo suma(cabe decir que irá convirtiendo el ascii a numero antes de
;sumar), y luego al final valida si el numero es negativo o positivo, si es
;negativo lo vuelve a negar y imprime un - y luego el numero de ser positivo
;solo lo imprime

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Verifica si es negativo o postivo
makeSum:

  cmp byte[r8+rcx], 0
  jz endMakeSum

  cmp byte[r8+rcx], 0x2B
  jz plus

  cmp byte[r8+rcx], 0x2D
  jz less

  inc rcx
  jmp makeSum

;Acá ira construyendo el numero, notese que es distinto a la resta
;solo en una linea, cuando salta ya que si es positivo NO hay que negarlo
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

;Acá acabo de leer el numero a sumar a resultado
;pero si viene negativo, hay que negarlo
;y añadirlo al resultado

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
  neg rax;ACA LO NIEGA
  add r13, rax
  jo error64bitsMore
  mov r9,0
  cleanEtiquete num1, 20
  jmp makeSum

endMakeSum:
  cmp r13, 0
  jl itsANegativeResult
endR:

  ret

; si es negativo imprime el menos
itsANegativeResult
  neg r13
  cGRegister
  print menos
  cGRegisters
  jmp endR

error64bitsMore:
  print error04
  endProgram
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;Funcion que valida que se escriba correctamente las variables
;y verifica que no hayan variables negativas, además guarda
;las variables que se usaran para verificar si estan dentro del programa

;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

variablesValidations:
  cmp byte[expresion+rcx], 0xA
  jz errorInVariables

  cmp byte[expresion+rcx], ","
  jz startValidationsC

  inc rcx
  jmp variablesValidations

startValidationsC:
  inc rcx
  cmp byte[expresion+rcx], " "
  jnz errorInVariables
  inc rcx

ciclo:
  cmp byte[expresion+rcx], 0xA
  jz allGoodInVariables

  cmp byte[expresion+rcx], ","
  jz startValidationsC

  cmp byte[expresion+rcx], "-"
  jz errorInVariables

  cmp byte[expresion+rcx], 0x40
  jg itsAletter

  inc rcx
  jmp ciclo

itsAletter:
  mov bl, byte[expresion+rcx]
  mov byte[variablesForValidation+r9], bl
  inc rcx
  inc r9
  jmp ciclo

errorInVariables:
  print error01
  cRegisters
  endProgram

allGoodInVariables:
  cRegisters
  ret
;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

;La siguiente funcion verifica que todas las variables de la expresion existan

;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

allTheVariablesOfTheExpresion:

  cmp byte[expresion+rcx], ","
  jz allGoodInEXOV

;Si es una letra la manda a verificar
  cmp byte[expresion+rcx], 0x40
  jg itsAletterSoVerificated


  inc rcx
  jmp allTheVariablesOfTheExpresion


;aca la manda a verificar
itsAletterSoVerificated:

  mov bl, byte[expresion+rcx]
  mov byte[characterToCompare], bl
  call strInTextX
  cmp rax, 3
  jnz errorInVariableNotFound

  inc rcx
  jmp allTheVariablesOfTheExpresion
;Si encontró error cierra el prgrama
errorInVariableNotFound:
  print error02
  endProgram

allGoodInEXOV:
  cRegisters
  ret

;Si encuentra el caracter el string deja en rax un 3 de lo contrario no
strInTextX:
  mov r9,0
  pStr:
    cmp byte[variablesForValidation+r9], 0
    jz endProcessStr

    mov bl, byte[characterToCompare]
    cmp byte[variablesForValidation+r9],bl
    jz isInString

    inc r9
    mov rax, 2
    jmp pStr
    isInString:
      mov rax, 3
 endProcessStr:
  ret
;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

;La siguiente funcion analiza que no haya incrouengias en la expresion
;como dos operandos seguidos, que el primer elemento no sea negativo
;o que no haya operando sin numero

;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

analizeExpresion:

  cmp byte[expresion+rcx], ","
  jz allGoodInExpresion

  cmp byte[expresion], "-"
  jz errorInExpresion

  cmp byte[expresion+rcx], "+"
  jz checkSides

  cmp byte[expresion+rcx], "-"
  jz checkSides

  cmp byte[expresion+rcx], "*"
  jz checkSides

  cmp byte[expresion+rcx], "/"
  jz checkSides

  inc rcx
  jmp analizeExpresion

;Se encarga de validar si a los lados del operando hay un algo valido
checkSides:

  dec rcx

  cmp byte[expresion+rcx], 0x2F
  jng errorInExpresion

  add rcx, 2

  cmp byte[expresion+rcx], 0x2F
  jng errorInExpresion

  inc rcx
  jmp analizeExpresion

errorInExpresion:
  print error03
  endProgram

allGoodInExpresion:
  cRegisters
  ret
;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV









;FIN DE CODIGO
