section .text  ; segmento que contiene las intruciones a ejecutar
global _start  ; se declara para ser enlazaado por gcc (ld) 
_start:  ; inicio del programa y punto de entrada
        mov ecx, 0x0  ; ecx = 0 -> se coloca valor de registro contador en cero
        mov eax, [veces]  ; eax = [veces] -> se asigna al registro eax el valor de (la variable estática inicializada) veces
        jmp ciclo_for  ; salta a la etiqueta 'ciclo_for'
salir:
        mov eax, 1  ; llamada a sistema exit
        int 0x80  ; llamada a kernel

ciclo_for:
        cmp eax,ecx  ; compara (SUB) el contenido del registro contador (ecx) con el contenido del registro eax (variable veces) -> ecx = veces? 
        je salir ; salta a 'salir' si son iguales (ZF=1) porque termina el ciclo for
        inc ecx  ; en caso contrario, se incrementa el registro contador ecx en 1
        jmp ciclo_for  ; salta a 'ciclo_for' para continuar con el for


section .data  ; segmento  que contiene las variables globales y estáticas inicializadas
        veces: db 0x9  ; variable (estática y global inicializada) que indica el valor del número de veces para el ciclo for
