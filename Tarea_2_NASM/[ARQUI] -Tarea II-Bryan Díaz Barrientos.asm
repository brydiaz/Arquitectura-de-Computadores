;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Tarea #2 		[Arqui]-Tarea#2- Bryan Díaz Barrientos  ;
;	Objetivo:Recibir un numero en str y convertirlo a numero;
;		 y a su equivalente binario			;
;	Inputs: Str que da el usuario				;
;	Outputs: Int del numero Str del binario			;
; 								;							   ,
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%include "io.mac"

.DATA 

inicio db "Bienvenido por favor digite su Palabra",0
en_numero db "Su palabra en numero es:",0
a_binario db "Su palabra en binario es:",0
Punto db ".",0
Signo db "-",0
se_acabo db "Gracias por usar el programa",0

.UDATA

string resb 10


.CODE

	.STARTUP

	PutStr inicio		;Imprime en pantalla el mensaje de inicio
	nwln			;Imprime nueva linea en pantalla
	GetStr string, 10 	;Guardamos el cadena de caracteres en nuestro string
	sub EBX, EBX		;Limpia el registro EBX
	mov EBX, string 	;Salvamos nuestro string
	sub EDX, EDX		;Limpia el registro EDX
	sub EAX, EAX		;Limpia el registro EBX
	mov EDX, 0		;Mueve un 0 a EDX
	sub CX, CX		;Limpia el registro CX
	mov CX, 0		;Mueve un 0 a CX
	PutStr en_numero	;Imprime en pantalla la variable en numero
	jmp recorrer_palabra	;Salta a recorrer el string
	nwln			;Imprime nueva linea en pantalla

FIN:

	PutStr se_acabo		;Imprime en pantalla la variable se_acabo
	
	.EXIT
	
	
convertir_a_numero:

	mov EBX, string		;Mueve el string a EBX
label:

	dec CX			;Reduce en 1 el CX
label2:
	sub EDX, EDX		;Limpia el EDX
	cmp byte[EBX], 0	;Compara si termino el recorrido
	je mostrar_numero	;Salta a mostrar el numero si ya se recorrio
	
	cmp byte[EBX], "-"	;Compara si el primer caracter es un signo
	je signo2		;Salta si es igual
	
	mov DL, byte[EBX]	;Mueve al DL lo que haya en el byte de EBX
	sub EDX, "0"		;Resta para obtener el numero
	add EAX, EDX		;Suma a su resultado
	
	cmp CX, 0		;Compara si el contador es 0
	jne multi		;Salta sino es igual

	inc EBX			;Incrementa el EBX
	jmp label		;Salta a label

recorrer_palabra:
	
	cmp byte[EBX], 0	;Compara si es 0
	je convertir_a_numero 	;Si es 0 salta a convertir numero
	cmp byte[EBX], "-"	;Compara si es un menos
	je signo1		;Brinca a si es un signo
	inc EBX			;Mueve al siguiente caracter
	inc CX			;Incrementa en 1 el contador
	jmp recorrer_palabra	;Salta para volver a hacer el ciclo

	

multi:
	sub EDX, EDX	;Resta lo que haya en EDX
	mov EDX, 10	;Mueve a EDX un 10
	mul EDX		;Multiplica 10 por lo que haya en EAX
	inc EBX		;Incrementa el EBX siguiente caracter
	jmp label	;Salta a label


mostrar_numero:
	
	PutLInt EAX	;Imprime el numero almacenado en EAX
	nwln		;Imprime un nwln
	PutStr a_binario ;Imprime en pantalla la variable a_binario	
	
	sub EBX, EBX	;Limpia EBX
	mov EBX, string	;Mueve de nuevo el string a EBX

	sub EDX,EDX 	;Limpia el EDX
	sub ECX, ECX	;Limpia ECX
	mov ECX, 32	;Mueve el 32 a ECX
	mov EDX, 80000000H ;Mueve la cantidad a EDX mascara

	cmp byte[EBX], "-"  ;Compara si es un negativo
	je binario_negativo ;Salta al proceso de negativos
	
	jmp convertir_a_binario ;Salta a convertir a binario


signo1:
	inc EBX		;Incrementa el ebx siguiente caracter
	jmp recorrer_palabra	;Salta a recorrer palabra
	
signo2:

	inc EBX		;Incrementa el ebx siguiente caracter
	PutStr Signo	;Imprime un Signo
	jmp label2	;Salta a label2
		

convertir_a_binario:

	test EAX, EDX	;Prueba como un and pero sin modificar EAX con EDX
	jz print0	;Salta si la bandera de 0 esta encendidad
	PutCh "1"	;Imprime un 1 en pantalla
	jmp skip1	;Salta a skip1


print0:
	PutCh "0"	;Imprime un 0 en pantalla
	
skip1:
	
	shr EDX, 1	;Mueve todos los bits una posicion
	loop convertir_a_binario ;Reduce contador y salta a convertir a binario
	nwln	;Imprime una nueva linea
	jmp FIN	;Salta al fin del programa
	
binario_negativo:
	
	PutStr Signo
	neg EAX ;Cambia negativo el EAX
	jmp convertir_a_binario ;Salta al final del programa





