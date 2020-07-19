;BIBLIOTECA DISEÑADA EN SU TOTALIDAD POR EL GRUPO DE TRABAJO
;SE PROHIBE SU USO SIN PREVIA AUTORIZACION.

section .data
  errorMessage: db 'UFF bro thats iligal D:', 0xA, 0
  errorMessageLen: equ $-errorMessage

  digits: db '0123456789ABCDEF',0
	digitsLen: equ $-digits

	longBar: db '=============================================', 0xA,0
	longBarLen: equ $-longBar

  nwLn db "",0xA,0
  nwLnLen: equ $-nwLn

;Esta macro esta basada pero mejorada en una funcion
;print que ya habíamos utilizado antes. Lo unico que hace
;es recorrer el string hasta encontrar 0, ya que si lo hacíamos
;normalmente, el print normal presentaba problemas de impresion
%macro print 1:
  mov rbx, %1
  mov rax, rbx
  mov rdx, 0
  %%repit:
    mov cl, [rbx]
    cmp cl, 0
    jz %%end
    inc rdx
    inc rbx
    jmp %%repit
  %%end:
    mov rsi, rax
    mov rdi,1
    mov rax,1
    syscall
%endmacro
;Macro de print común y corriente, la usamos cuando queremos Imprimir
;strings que NO tienen un 0 al final, ya que sino da error
;recibe el string a imprimir y el tamaño en bytes exacto
%macro printForValue 2:
  mov rsi, %1
  mov rdx, %2
  mov rdi,1
  mov rax,1
  syscall
%endmacro

;Macro simple de input, recibe el lugar a guardar, y el tamaño
%macro input 2:
  mov rsi, %1
  mov rdx, %2
  mov rdi, 0
  mov rax, 0
  syscall
%endmacro

;Macro intuitiva no tiene, parametros, limpia TODOS los resgistros
%macro cRegisters 0:
  xor rsi, rsi
  xor rdi, rdi
  xor rax, rax
  xor rbx, rbx
  xor rdx, rdx
  xor rcx, rcx
  xor r8, r8
  xor r9, r9
  xor r10, r10
  xor r11, r11
  xor r12, r12
  xor r13, r13
  xor r14, r14
  xor r15, r15
  syscall
%endmacro
;Macro intuitiva no tiene, parametros, limpia los resgistros
;generales

%macro cGRegisters 0:

  xor rsi, rsi
  xor rdi, rdi
  xor rax, rax
  xor rbx, rbx
  xor rdx, rdx
  xor rcx, rcx
  syscall
%endmacro


;Esta macro se utilizó en una tarea pasada, solo se adapto
;en lugar se ser un call a una macro, recibe dos parametros
;el numero a convertir y la base para hacer su representacion
;convierte y guarda el numero EN UNA ETIQUETA.

%macro itoa 3:
  mov r15,0
  mov rax, %1
  mov rdi, %2
  xor rsi, rsi
  mov r11, digits
  mov rcx, 0
  jmp %%reConvertion
  %%findNumber:
    cmp rax, rcx
    jz %%endC
    inc r11
    inc rcx
    jmp %%findNumber
  %%endC:
    ret
  %%reConvertion:
    xor rdx, rdx
  	div rdi
  	push rdx
  	inc rsi
  	cmp rax,0
  	jnz %%reConvertion
  %%nextDigito:
    pop rax ;Lo saca de la pila
    call %%findNumber
    mov rax, [r11]
    push rsi;Guarda el contador
    xor rsi, rsi

    mov rdx, 1;Imprimir solo un byte
    mov rsi, rax;Muevo el caracter a imprimir



    push rax; Lo vuelve a meter a la pila
    mov rsi, rsp; el punto donde se esta

    mov r14b, byte[rsi]
    mov byte[%3+r15], r14b
    inc r15

    pop rax ;Limpia rax de la pila
    pop rsi ;Recuperamos contador

    dec rsi; lo bajamos
    cmp rsi, 0; revisa si termina
    mov r11, digits
    mov rcx, 0
    jg %%nextDigito

    mov r14, 0
    mov byte[%3+r15], 0
    mov r15, 0

%endmacro
;Esta macro recibe una palabra (EN GENERAL DEBERÍA SER UNA CADENA
;DE STRINGS como "23123") y devuelve en el rax el numero
;Esta macro se utilizó en una tarea pasada, solo se adapto
;en lugar se ser un call a una macro, recibe dos parametros
;convierte a entero y guarda el resultado en rax
%macro atoi 1:

  mov rdi, %1
  xor rsi, rsi
  mov rax, 0
  %%convertion:
    movzx rsi, byte[rdi]
	  cmp rsi, 0
	  jz %%end

	  cmp rsi, 48
	  jl %%error1

	  cmp rsi, 57
	  jg %%error1

	  sub rsi, 48
	  imul rax, 10
	  add rax, rsi

	  inc rdi
	  jmp %%convertion

    %%error1:
      print errorMessage
      endProgram
    %%end:

%endmacro
;Macro intuitiva no tiene parametros, cierra el programa
%macro endProgram 0:
    cRegisters
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro
;Funcion adaptada a macro de la tarea pasada
;Imprime el numero en todas las bases hasta de 2 a 16
;ademas recibe un string que bien puede ser un identificador
;ejemplo numero: 5 (en base) 2: 101 *()sería el string
%macro inAllTheBases 2:
  cGRegisters
  mov r8, 2
  %%star:
    cmp r8, 17
    jz %%end
    print %2
    itoa r8, 10
    print nwLn
    itoa %1, r8
    print nwLn
    print longBar
    inc r8
    jmp %%star
  %%end:
%endmacro

%macro isNumber 1:
  mov bl, %1
  cmp bl, 2Fh
  jng %%notANumber

  cmp bl, 39h
  jg %%notANumber

  mov rax, 3;Sí es un numero
  jmp %%end

  %%notANumber:
    mov rax, 2;No es un numero
    jmp %%end

  %%end:
%endmacro

%macro addChar 2:

  mov rbx, %1
  mov rdx, 0
  %%ultimaPos:
    mov cl, [rbx]
    cmp cl, 0
    jz %%lastPosicion
    inc rbx
    inc rdx
    jmp %%ultimaPos
  %%lastPosicion:
    mov byte[%1+rdx], %2
    inc rdx
    mov byte[%1+rdx], 0
%endmacro

;Si está dentro deja un 2 rax y en rcx, la posicion donde esta
%macro strIn 2:
  mov rcx,0

  %%process:
      cmp byte[%1+rcx], 0
      jz %%endProcess

      cmp byte[%1+rcx], %2
      jz %%isIn

      inc rcx
      mov rax, 2
      jmp %%process
  %%isIn:
      mov rax, 3
  %%endProcess:

%endmacro


%macro cleanEtiquete 2:
  mov r10, 0
  %%loopProcess:
    cmp r10, %2
    jz %%endLoopProcess

    mov byte[%1+r10],0
    inc r10
    jmp %%loopProcess
  %%endLoopProcess:
    mov r10,0
%endmacro
