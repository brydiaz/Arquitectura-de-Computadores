;MACRO MODIFICADA POR BRYAN DÍAZ
;APORTA 3 FUNCIONES
;readFile QUE NECESITA 3 PARAMETRO EL NOMBRE DEL ARHIVO A LEER, DONDE GUARDAR, TAMAÑO A GUARDAR
;writeFile QUE NECESITA 3 PARAMETROS EL NOMBRE DEL ARCHIVO QUE VA A CREAR O ABRIR PARA ESCRIBIR
;EL CONTENIDO QUE SE QUIERE ESCRIBIR, Y EL TAMAÑO DEL CONTENIDO QUE SE VA A ESCRIBIR.

;fileRead GUARDA EL ARCHIVO DE TEXTO LEIDO EN RSI O LA ETIQUETA PARA SU MANIPULASION
;fileWrite SOLO ESCRIBE EL PARAMETRO EN UN ARCHIVO DE TEXTO, NO CONCADENA

;INDISPENSABLE QUE EN EL PROGRAMA QUE SE INCLUYA ESTA BIBLIOTECA
;SE INCLUYA EL ARCHIVO "linux64.inc" (Autor desconocido) DE LO CONTRARIO
;ESTE CODIGO NO FUNCIONARA

;EL TEXTO A LEER, EL TEXTO A GUARDAR, SE CARGARAN O GUARDARAN
;EN LA MISMA RUTA EN DONDE SE IMPORTE ESTA LIBRERIA

;ESTA ES UNA VERSION UNIFICADA Y MEJORADA DE FUNCIONES
;DE OTRO AUTOR(que se desconoce, creditos a quien lo reclame)
;QUE CON DISTINTAS MEJORAS Y UNIDOS EN UN SOLO
;MODULO, PROPORCIONA UN FILEMANAGER SENCILLO Y FACIL DE USAR


;En el primer argumento, recibe el nombre del archivo a guardar
;En el segundo recibe en el contenido a guardar
;En el tercero recibe el tamaño del argumento

%macro writeFile 3:
  mov rax, SYS_OPEN
  mov rdi, %1
  mov rsi, O_CREAT+O_WRONLY
  mov rdx, 0644o
  syscall

  push rax
  mov rdi, rax
  mov rax, SYS_WRITE
  mov rsi, %2
  mov rdx, %3
  syscall

  mov rax, SYS_CLOSE
  pop rdi
  syscall
%endmacro

;En el primer argumento, recibe el nombre del archivo a abrir
;En el segundo recibe en que etiqueta se guardara el contenido
;En el tercero recibe el tamaño del argumento

%macro readFile 3:

  mov rax, SYS_OPEN
  mov rdi, %1
  mov rsi, O_RDONLY
  mov rdx, 0
  syscall

  push rax
  mov rdi, rax
  mov rax, SYS_READ
  mov rsi, %2
  mov rdx, %3
  syscall

  mov rax, SYS_CLOSE
  pop rdi
  syscall

%endmacro

;Macro muy intuitiva, solo borra TODOS los registros

%macro cleanAllRegisters 1:

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
  syscall

%endmacro

;Borra los registros de uso general

%macro cleanGRegisters 1:

  xor rsi, rsi
  xor rdi, rdi
  xor rax, rax
  xor rbx, rbx
  xor rdx, rdx
  xor rcx, rcx
  syscall
%endmacro
