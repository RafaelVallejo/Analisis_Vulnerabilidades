; Vallejo Fernández Rafael Alejandro
; Generar un programa que cifre una cadena con al menos 5 instrucciones de
; ensamblador distintas, al menos una debe ser SHR o SHL con 
; corrimiento minimo de 3
section .text  ; segmento que contiene las intruciones a ejecutar
global _start  ; se declara para ser enlazaado por gcc (ld) 
_start:  ; inicio del programa y punto de entrada
        mov eax, [mensaje]  ; eax = [opcion] -> eax = 'a',0xa -> eax = "a\n"
        mov ecx, 0x1   ; contador para recorrer la cadena a descifrar, inicia en uno para no contar al final el salto de linea
        mov esi, mensaje  ; indice origen del bufer de datos de entrada -> mensaje
        mov edi, mensaje  ; indice destino donde se copiara el bufer de datos de entrada -> mensaje -> se sobreescribe el origen
        jmp cifra  ; salta a la etiqueta cifra
imprime:
        mov edx, len_mensaje  ; edx = len_mensaje  -> tamaño de mensaje
        mov ecx, mensaje  ; ecx = mensaje  -> buffer mensaje a escribirse
        mov ebx, 1  ; fd -> salida estándar
        mov eax, 4  ; llamada a sistema write
        int 0x80  ; llamada a kernel
        ret  ; termina procedimiento y regresa a la instrucción siguiente después de ser llamado
salir:
        mov eax, 1  ; llamada a sistema exit
        int 0x80  ; llamada a kernel
cifra:
        lodsb  ; se lee el byte de esi [mensaje] y se guarda en el reg al (para realizar el cifrado de caracter a caracter de la cadena introducida)
        mov dl,al  ; se mueve contenido de resgistro al a dl para poder realizar las operaciones de cifrado (dl será un reg aux)
        shl al,4  ; 1) se hace corrimiento del registro al a la izquierda de 4 bits
        shr dl,4  ; 1) se hace corrimiento del registro dl a la derecha de 4 bits  
        not al    ; 2) se niegan los bits del registro al
        xor al,dl  ; 3) se hace la operación xor del registro al, dl (con los corrimientos) y se almacena en el reg al
        rol al,2  ; 4) se realiza una rotación de 2 bits a la izquierda del registro al
        neg al    ; 5) se niegan los bits del registro al, se suma un 1 y se guarda en el registro al

        cmp al,0x7e  ; se compara con 0x7e para poder ser caracteres imprimibles
        ja cambiaMayor  ; si es mayor salta a etiqueta cambiaMayor
        cmp al,0x21  ; se compara con 0x21 para poder ser caracteres imprimibles
        jl cambiaMenor  ; si es menor salta a cambiaMenor
continua:
        stosb  ; guarda en el byte de edi [mensaje] el contenido del registro al (el caracter leido y sobreescrito de la cadena mensaje)
        inc ecx  ; se incrementa contador de caracteres leidos del mensaje
        cmp ecx, len_mensaje  ; se compara con el tamaño de la cadena para ver si se ha conlcuido
        jne cifra  ; en caso de que aun existan caracteres, salta a cifra para continuar cifrando (ciclo for)
        mov eax, mensaje  ; una vez que se termina, se asigna al registro eax el mensaje descifrado (sobreescrito en la misma variable)
        call imprime  ; se llama al procedimiento imprime
        jmp salir  ; una vez que retorna, va a la etiqueta salir
cambiaMenor:
        add al,0x20  ; si es menor se suma al registro al 0x20
        jmp continua  ; va a la etiqueta continua
cambiaMayor:
        sub al,0x70  ; se le resta 0x70 para no tener caracteres erroneos para el descifrado (especificamente los ' ')
        jmp continua  ; salta a continua para los siguientes caracteres a descifrara

section .data  ; segmento  que contiene las variables globales y estáticas inicializadas
        ;mensaje: db 'abcdefghijklmnopqrstuvwxyz',0xa
        mensaje: db 'cifra_cadenas_con_letras_minusculas_separadas_con_guion_bajo',0xa  ; cadena mensaje= "No valido\n"
        len_mensaje: equ $-mensaje  ; tamaño de cadena mensaje -> len(mensaje) = 10
