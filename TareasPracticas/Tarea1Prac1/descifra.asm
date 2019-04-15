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
        jmp descifra  ; salta a la etiqueta cifra
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
descifra:
        lodsb  ; se lee el byte de esi [mensaje] y se guarda en el reg al (para realizar el cifrado de caracter a caracter de la cadena introducida)
        sub al,0x01  ; se resta uno del mensaje cifado por el neg que se realizó al final
        not al  ; se niega para invertir lo realizado por neg
        ror al,2  ; se rota dos a la derecha para invertir el rol al,2
        not al  ; se niega al para llegar al caracter original pero falta intercambiar los 4 bits mas signi por los 4 menos signif
        mov dl,al  ; se copia el contenido de al en dl para invertir los bits
        shl dl,4  ; se hace corrimiento a la izqueirda para invertir shr dl,4 y para intercambia los bits mas signi por los menos signif
        shr al,4  ; corrimiento a la derecha para invertir shl al,4
        or al,dl  ; or al,dl que se guarda en al para obtener el caracter original luego de intercambiar los 4 bits mas sig por los 4 menos sign
        cmp al,0x7e  ; se compara con 0x7e para poder ser caracteres imprimibles
        ja cambiaMayor  ; si es mayor salta a etiqueta cambiaMayor
        cmp al,0x21  ; se compara con 0x21 para poder ser caracteres imprimibles
        jl cambiaMenor  ; si es menor salta a cambiaMenor  
continua:
        stosb  ; guarda en el byte de edi [mensaje] el contenido del registro al (el caracter leido y sobreescrito de la cadena mensaje)
        inc ecx  ; se incrementa contador de caracteres leidos del mensaje
        cmp ecx, len_mensaje  ; se compara con el tamaño de la cadena para ver si se ha conlcuido
        jne descifra  ; en caso de que aun existan caracteres, salta a descifra para continuar descifrando (ciclo for)

        mov eax, mensaje  ; una vez que se termina, se asigna al registro eax el mensaje descifrado (sobreescrito en la misma variable)
        call imprime  ; se llama al procedimiento imprime
        jmp salir  ; una vez que retorna, va a la etiqueta salir
cambiaMenor:
        add al,0x20  ; si es menor se suma al registro al 0x20
        jmp continua  ; va a la etiqueta continua
; para obtener el descifrado correcto utilice gdb y ver lo que ocurría con los caracteres que se imprimían erróneamente.
; gracias a ello obtuve lo siguiente
cambiaMayor:
        cmp al,0xf0  ; los caracteres p t x tienen valores mayores a f0, por lo que se compara si se trata de alguno de ellos
        jae resta  ; en caso de ser mayor o igual, salta a resta (0x80) para obtener su caracter imprimible en hex 0x7Y
        mov bl,al  ; se hace uso del registro bl como reg aux. Se asigna a bl el contenido de al
        and bl,0xf0  ; los caracteres obtenidos y antes de imprimirse, deben estar en el rango de 0x6Y, este es para el caso de las letras d h l
        cmp bl,0xe0  ; se compara el reg aux bl con e0 para obtener en la resta un 0x6Y (para el caso de las letras d h l)
        je resta  ; en caso de ser igual, va a resta
        sub al,0x3e ; los caracteres obtenidos y antes de imprimirse, deben estar en el rango de 0x6Y, por eso se les resta 0x3e ya que el resto de caracteres tiene valores de a0 hasta b8
        jmp continua  ; salta a continua para los siguientes caracteres a descifrar
resta:
        sub al,0x80  ; resta 0x80 para obtener su caracter imprimible en hex 0x7Y
        jmp continua  ; salta a continua para los siguientes caracteres a descifrar
section .data  ; segmento  que contiene las variables globales y estáticas inicializadas
        mensaje: db 'i[*-YhiY:Z,Ymhil,h<Z>-Ymh\[,^mi^<YmhmZ=Y-Y:Ymhil,hj^[l,h)Y+l', 0xa  ; cadena mensaje a descifrar
        len_mensaje: equ $ - mensaje  ; tamaño de cadena mensaje -> len(mensaje) = 10