;Este codigo es propio del grupo
;Aunque usa una variable del linux.inc
;por ende donde se cargue este programa debe
;cargarse.
;Recibe dos parametros,dos numeros, el primero debe ser el más
;e imprimirá el resultado del porcentaje de diferencia en pantalla
 
section .data

  porcentaje db "%", 0xA, 0

%macro obtPorcentaje 2:

  mov eax, 100
  mov ebx, %1;(numero menor)
  mul ebx
  mov ebx, %2;(numero mayor)
  div ebx

  printVal rax
  print porcentaje
  syscall
%endmacro
