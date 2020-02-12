;FIRST SHORT HOMEWORK IN NASM 


section .data
	message: db "Hello World!!", 0xA ;Mensaje inicial
	messageLen: equ $-message

	questionOne: db "Are you going to change the message?", 0xA; Mensaje de cambio
	questionOneLen: equ $-questionOne

	options: db "1.Yes 2. No, please choice one", 0xA ;Mensaje de opcion
	optionsLen: equ $-options

	newMessage: db "Please write a new message...", 0xA; Mensaje nuevo
	newMessageLen: equ $-newMessage

	endMessage: db "Thanks for use me :D", 0xA;Mensaje de despedida
	endMessageLen: equ $-endMessage

section .bss

	variable resb 100 ;Reservar espacio en para el posible mensaje


section .start
	
	global _start  ;EL programa empezara aquí

_start:
	

;EN ESTA PARTE EL PROGRAMA IMPRIME EN CONSOLA EL HOLA MUNDO
;ADEMAS DESPLIEGA EL LOS MENSAJES SI DESEA CONTINUAR 


	mov eax, 4; Llama al sistema para que escriba
	mov ebx, 1; Ficheros STDOUT
	mov ecx, message; Pasa el mensaje como paramtro
	mov edx, messageLen; Pasa el largo como parametro
	
	int 0x80; interrupcion 

continueProgram:

	mov eax, 4; Llama al sistema para que escriba
	mov ebx, 1; Ficheros STDOUT
	mov ecx, questionOne; Pasa el mensaje como paramtro
	mov edx, questionOneLen; Pasa el largo como parametro
	
	int 0x80; interrupcion 

	mov eax, 4; Llama al sistema para que escriba
	mov ebx, 1; Ficheros STDOUT
	mov ecx, options; Pasa el mensaje como paramtro
	mov edx, optionsLen; Pasa el largo como parametro
	int 0x80

	mov eax, 3;LLama al sistema para leer
	mov ebx, 0; Fichero STDIN
	mov ecx, variable; Mueve lo obtenido a la variable
	mov edx, 5; reserva un bit
	int 0x80
	
	cmp byte[ecx], '1';Compara el primer byte con el caracter uno
	jz new_message ;Si la resta da cero entonces salta a el nuevo mensaje
	int 0x80

	jmp endOfTheProgram; si la resta dio uno entonces termina el programa
	
	int 0x80; interrupcion 
	
new_message:

	mov eax, 4; Llama al sistema para que escriba
	mov ebx, 1; Ficheros STDOUT
	mov ecx, newMessage; Pasa el mensaje como paramtro
	mov edx, newMessageLen; Pasa el largo como parametro
	int 0x80

	mov eax, 3;LLama al sistema para leer
	mov ebx, 0; Fichero STDIN
	mov ecx, variable; Mueve lo obtenido a la variable
	mov edx, 100; reserva un bit
	
	int 0x80

	mov eax, 4; Llama al sistema para que escriba
	mov ebx, 1; Ficheros STDOUT
	mov ecx, variable; Pasa el mensaje como paramtro
	mov edx, 100; Pasa el largo como parametro
	
	int 0x80
	
	jmp continueProgram;Continua el programa
	int 0x80

endOfTheProgram:

	mov eax, 4; Llama al sistema para que escriba
	mov ebx, 1; Ficheros STDOUT
	mov ecx, endMessage; Pasa el mensaje como paramtro
	mov edx, endMessageLen; Pasa el largo como parametro
	int 0x80


	mov ebx,0	
	mov eax,1
	int 0x80;

	
;FIN DE PROGRAMA
