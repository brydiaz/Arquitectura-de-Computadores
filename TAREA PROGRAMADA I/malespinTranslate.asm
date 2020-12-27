;ESTE PROGRAMA NECESITA DE DONDE SE IMPORTE, TENER
;EL ARCHIVO "linux64.inc" EN LA MISMA CARPETA
;SINO SERÁ DE INCORRECTO FUNCIONAMIENTO
;RECIBE DOS PARAMETROS EN EL CUAL
;EL PRIMERO SEA EL MENSAJE A TRADUCIR Y EL SEGUNDO UN CONTADOR
;EJEMPLO DE LLAMADA:
;----------------------------
;malEsp texto, rdx(en rdx un 0)
;---------------------------
;Dejará en el texto, una version convertida del mismo y en rdx, la cantidad
;de caracteres que recorrió

;Apesar de ser gigante el metodo es muy sencillo, basicamente pregunta
;si la letra que hay es una de las que hay que cambiar, si lo es, ya sea minus
;o mayus la cambiara por su equivalente, por eso no importa si el texto está en
;malespin o español, ya que la traduccion es absoluta, claro está, depende de que
;el usuario no mezcle idiomas, sino obtendra equivalente traducido

;malespin es:

;a por e
;i por o
;b por t
;f por g
;p por m

section .data

%macro malEsp 2


%%espAmal:

	cmp byte[%1+%2], 0
	jz %%end

	cmp byte[%1+%2], 0x20
	jz %%next

	cmp byte[%1+%2], 0x41;A
	jz %%AXE

	cmp byte[%1+%2], 0x45;E
	jz %%EXA

	cmp byte[%1+%2], 0x61;a
	jz %%axe

	cmp byte[%1+%2], 0x65;e
	jz %%exa

	cmp byte[%1+%2], 0x49;I
	jz %%IXO

	cmp byte[%1+%2], 0x4F;O
	jz %%OXI

	cmp byte[%1+%2], 0x69;i
	jz %%ixo

	cmp byte[%1+%2], 0x6F;o
	jz %%oxi

	cmp byte[%1+%2], 0x42;B
	jz %%BXT

	cmp byte[%1+%2], 0x54;T
	jz %%TXB

	cmp byte[%1+%2], 0x62;b
	jz %%bxt

	cmp byte[%1+%2], 0x74;t
	jz %%txb

	cmp byte[%1+%2], 0x46;F
	jz %%FXG

	cmp byte[%1+%2], 0x47;G
	jz %%GXF

	cmp byte[%1+%2], 0x66;f
	jz %%fxg

	cmp byte[%1+%2], 0x67;g
	jz %%gxf

	cmp byte[%1+%2], 0x50;P
	jz %%PXM

	cmp byte[%1+%2], 0x4D;M
	jz %%MXP

	cmp byte[%1+%2], 0x70;p
	jz %%pxm

	cmp byte[%1+%2], 0x6D;m
	jz %%mxp

	inc %2
	jmp %%espAmal

;CONVERSION DE A a E EN VICEVERSA EN MINUSCULA Y MAYUSCULA
%%AXE:

	mov byte[%1+%2], 0x45;E
	inc %2
	jmp %%espAmal

%%EXA:

	mov byte[%1+%2], 0x41;A
	inc %2
	jmp %%espAmal

%%axe:

	mov byte[%1+%2], 0x65;e
	inc %2
	jmp %%espAmal

%%exa:

	mov byte[%1+%2], 0x61;a
	inc %2
	jmp %%espAmal

;CONVERSION DE I a O EN VICECERSA EN MINUSCULA Y MAYUSCULA

%%IXO:

	mov byte[%1+%2], 0x4F;O
	inc %2
	jmp %%espAmal

%%OXI:

	mov byte[%1+%2], 0x49;I
	inc %2
	jmp %%espAmal

%%ixo:

	mov byte[%1+%2], 0x6F;o
	inc %2
	jmp %%espAmal

%%oxi:

	mov byte[%1+%2], 0x69;i
	inc %2
	jmp %%espAmal

;CONVERSION DE B a T EN VICEVERSA EN MINUSCULAS Y MAYUSCULAS

%%BXT:

	mov byte[%1+%2], 0x54;T
	inc %2
	jmp %%espAmal

%%TXB:

	mov byte[%1+%2], 0x42;B
	inc %2
	jmp %%espAmal

%%bxt:

	mov byte[%1+%2], 0x74;t
	inc %2
	jmp %%espAmal

%%txb:

	mov byte[%1+%2], 0x62;b
	inc %2
	jmp %%espAmal

;CONVERSION DE F a G EN VICEVERSA EN MINUSCULAS Y MAYUSCULAS

%%GXF:

	mov byte[%1+%2], 0x46;F
	inc %2
	jmp %%espAmal

%%FXG:

	mov byte[%1+%2], 0x47;G
	inc %2
	jmp %%espAmal

%%gxf:

	mov byte[%1+%2], 0x66;f
	inc %2
	jmp %%espAmal

%%fxg:

	mov byte[%1+%2], 0x67;g
	inc %2
	jmp %%espAmal

;CONVERSION DE P a M EN VICEVERSA EN MINUSCULAS Y MAYUSCULAS

%%PXM:

	mov byte[%1+%2], 0x4D;M
	inc %2
	jmp %%espAmal

%%MXP:

	mov byte[%1+%2], 0x50;P
	inc %2
	jmp %%espAmal

%%pxm:

	mov byte[%1+%2], 0x6D;m
	inc %2
	jmp %%espAmal

%%mxp:

	mov byte[%1+%2], 0x70;p
	inc %2
	jmp %%espAmal


%%next:

	inc %2
	jmp %%espAmal

%%end:

%endmacro
