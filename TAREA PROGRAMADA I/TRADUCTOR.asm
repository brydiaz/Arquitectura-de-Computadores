%include "linux64.inc"
%include "fileManagerV1.asm"
%include "malespinTranslate.asm"
%include "comparadorDeTexto.asm"
%include "porcentajes.asm"

;Variables inicializadas
;Se comentaran las lineas que no sean asumibles
;los prints e inputs estan dentro de la "Linux64.inc"
;Para la correcta ejecucion del programa se necesita sí o sí
;la implementacion del de las bibliotecas "linux64.inc", fileManagerV1.asm
;malespinTranslate.asm, y comparadorDeTexto

section .data

  saludo db "Bienvenido usuario!!", 0xA,0
  saludoII db "¿Como desea traducir de Español-Malespin y vicecersa?",0xA, 0
  opcionesMenu db "1. Deseo escribir desde consola, 2. No, mejor desde archivo ",0xA, 0
  pedirMensaje db "Por favor inserte el mensaje :D", 0xA, 0
  esperando db "Esperando....",0xA, 0
  comprobante db "El mensaje se guardo exitosamente en malEsp.txt",0xA, 0
  nombreTexto db "malEsp.txt",0
  pruebas db "Todo gucci", 0xA, 0
  mensajeFinal db "Gracias por usar :D", 0xA, 0
  nwLn db "", 0xA, 0

  archivoSalida db "Archivo de salida modificado: malEsp.txt", 0xA,0
  letrasTotal db "Total de letras leídas del programa: ",0xA,0
  palabrasTotal db "Total de palabras leídas del programa: ", 0xA, 0
  letrasCambiadas db "Total de letras cambiadas del programa: ", 0xA, 0
  palabrasCambiadas db "Total de palabras cambiadas del programa: ", 0xA, 0
  porcenLetras db "El porcentaje de letras cambiadas del programa: ",0xA,0
  porcenPalabras db "El porcentaje de palabras cambiadas del programa: ",0xA,0
;Variables no-inicializadas

section .bss

  opcion resb 2
  texto resb 2048
  textoOriginal resb 2048

section .text

  global _start

_start:

  cleanAllRegisters rsi;Limpia TODOS los registrios (La macro esta dentro del file Manager)

  print saludo
  print saludoII
  print opcionesMenu
  print esperando

  input opcion, 2

  cmp byte[opcion], 0x31
  je leerDesdeConsola ;Se compara si el usuario elige traducir desde consola o desde el archivo malEsp.txt

  cmp byte[opcion], 0x32
  je leerDesdeArchivo ;Se compara si el usuario elige traducir desde consola o desde el archivo malEsp.txt

  exit

;En esta funcion el usuario ingresa el mensaje y este mensaje con la macro malEsp (Ubicada en malespinTranslate.asm)
;Es convertido a malespin o a español, despues con la macro de writeFile(Ubicada en fileManagerV1)
;escribe dentro de un archivo convertido, luego lee el archivo con readFile(Ubicada en fileManagerV1), y lo vuelve
;a traducir para así obtener el texto convertido, y el texto original, para así utilzar las macros contarPalabrasDistintas
;y comparadorDeTexto (Ubicadas en comparadorDeTexto.asm), para poder obtener la cantidad de letras, palabras,
;palabras cambiadas y letras cambiadas CADA UNA DE LAS MACROS ESTARÁ EXPLICADA EN SU RESPECTIVO ARCHIVO

leerDesdeConsola:

  print pedirMensaje
  input texto, 2048
  malEsp texto, r14
  writeFile nombreTexto, texto, 2048
  readFile nombreTexto, textoOriginal, 2048
  xor r14, r14
  malEsp textoOriginal, r14
  print nwLn
  xor r14, r14
  xor r13, r13
  contarPalabrasDistintas texto, r14, r13, textoOriginal
  comparador texto, r8, r9, r10, r12, r11, textoOriginal
  call impresionCorrecta
  print porcenLetras
  obtPorcentaje r12d, r9d
  print porcenPalabras
  obtPorcentaje r13d, r10d
  print nwLn
  print mensajeFinal
  print nwLn
  exit

;En esta funcion el usuario carga el mensaje desde el archivo original a dos variables texto y textoOriginal
;despues de esto convierte texto con malEsp para así utilzar las macros contarPalabrasDistintas
;y comparadorDeTexto (Ubicadas en comparadorDeTexto.asm), para poder obtener la cantidad de letras, palabras,
;palabras cambiadas y letras cambiadas
leerDesdeArchivo:

  readFile nombreTexto, texto, 2048
  readFile nombreTexto,textoOriginal, 2048
  mov r14, 0
  malEsp texto, r14
  writeFile nombreTexto, texto, 2048
  xor r14, r14
  xor r13, r13
  contarPalabrasDistintas texto, r14, r13, textoOriginal
  comparador texto, r8, r9, r10, r12, r11, textoOriginal
  call impresionCorrecta
  print porcenLetras
  obtPorcentaje r12d, r9d
  print porcenPalabras
  obtPorcentaje r13d, r10d
  print nwLn
  print mensajeFinal
  print nwLn
  exit

;En esta funcion se hace uso de un mecanismo ya implementado en un tarea corta pasada
;el itoa, basicamente imprime en el formato que el profesor deseaba, y llama a la funcion
;(pasandole los parametros necesarios para se ejecucion antes de llamarla, se marcaran con una x)
;que convierte el numero a ascii.

impresionCorrecta:

  print archivoSalida
  print letrasTotal
  cleanGRegisters rsi;Limpia solo los registros de uso general
  mov rax, r9;x
	mov rdi, 10;x
	xor rsi, rsi;Limpieza necesaria
	call reConvertion;Llamada a la funcion
  print nwLn

  print palabrasTotal
  cleanGRegisters rsi
  mov rax, r10
	mov rdi, 10
	xor rsi, rsi
	call reConvertion
  print nwLn

  print letrasCambiadas
  cleanGRegisters rsi
  mov rax, r12
	mov rdi, 10
	xor rsi, rsi
	call reConvertion
  print nwLn

  print palabrasCambiadas
  cleanGRegisters rsi
  mov rax, r13
	mov rdi, 10
	xor rsi, rsi
	call reConvertion
  print nwLn

  ret

;Divide el numero y mete los residuos en la pila

reConvertion:

	xor rdx, rdx
	div rdi
	push rdx
	inc rsi
	cmp rax,0
	jnz reConvertion

nextDigito:

	pop rax ;Lo saca de la pila
	add rax, '0';Convierte el caracter
	push rsi;Guarda el contador
	xor rsi, rsi

	mov rdx, 1;Imprimir solo un byte
	mov rsi, rax;Muevo el caracter a imprimir

	push rax; Lo vuelve a meter a la pila
	mov rsi, rsp; el punto donde se esta

  mov rax,1
  mov rdi,1
	syscall

	pop rax ;Limpia rax de la pila
	pop rsi ;Recuperamos contador

	dec rsi; lo bajamos
	cmp rsi, 0; revisa si termina
	jg nextDigito

	ret
