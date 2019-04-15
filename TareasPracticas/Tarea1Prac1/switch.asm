section .text  ; segmento que contiene las intruciones a ejecutar
global _start  ; se declara para ser enlazaado por gcc (ld) 
_start:  ; inicio del programa y punto de entrada
        mov eax, [opcion]  ; eax = [opcion] -> eax = 'a',0xa -> eax = "a\n"
        jmp switch  ; salta a la etiqueta switch
imprime:
        mov edx, len_opcion  ; edx = len_opcion  -> tamaño de opción
        mov ecx, opcion  ; ecx = opcion  -> buffer opción a escribirse
        mov ebx, 1  ; fd -Z salida estándar
        mov eax, 4  ; llamada a sistema write
        int 0x80  ; llamada a kernel
        ret  ; termina procedimiento y regresa a la instrucción siguiente después de ser llamado
imprime_no_valido:
        mov edx, len_mensaje  ; edx = len_mensaje -> tamaño de mensaje
        mov ecx, mensaje  ; ecx = mensaje -> buffer mensaje a escribirse
        mov ebx, 1  ; fd -> salida estándar
        mov eax, 4  ; llamada a sistema write
        int 0x80  ; llamada a kernel
        ret  ; termina procedimiento y regresa a la instrucción siguiente después de ser llamado 
salir:
        mov eax, 1  ; llamada a sistema exit
        int 0x80  ; llamada a kernel

switch:
        cmp al, 'a'  ; compara (SUB) 'a' con contenido de los 8 bits menos significativos del registro ax (que contiene la opción elegida) -> 'a' = al?
        je opcion_a  ; salta a opcion_a si son iguales (ZF=1)
        cmp al, 'b'  ; 'b' = al? ->
        je opcion_b  ; salta a opcion_b si son iguales (ZF=1)
        cmp al, 'c'  ; 'c' = al?
        je opcion_c  ; salta a opcion_c si son iguales (ZF=1)
        jmp defaultt  ; salta a defaultt si la opción no es válida
opcion_a:
        call imprime  ; se llama al procedimiento con la etiqueta imprime que muestra en la salida estándar la opción 'a'
        jmp salir  ; salta a la etiqueta salir que termina la ejecución del programa
opcion_b:
        call imprime  ; se llama al procedimiento con la etiqueta imprime que muestra en la salida estándar la opción 'b'
        jmp salir  ; salta a la etiqueta salir que termina la ejecución del programa
opcion_c:
        call imprime  ; se llama al procedimiento con la etiqueta imprime que muestra en la salida estándar la opción 'c'
        jmp salir  ; salta a la etiqueta salir que termina la ejecución del programa
defaultt:
        call imprime_no_valido  ; se llama al procedimiento con la etiqueta imprime_no_valido que muestra en la salida estándar que la opción no es válida
        jmp salir  ; salta a la etiqueta salir que termina la ejecución del programa
section .data  ; segmento  que contiene las variables globales y estáticas inicializadas
        opcion: db 'c', 0xa  ; cadena opción = "c\n"
        len_opcion: equ $ - opcion  ; tamaño de cadena opción -> len(opcion) = 2
        mensaje: db 'No valido', 0xa  ; cadena mensaje= "No valido\n"
        len_mensaje: equ $ - mensaje  ; tamaño de cadena mensaje -> len(mensaje) = 10