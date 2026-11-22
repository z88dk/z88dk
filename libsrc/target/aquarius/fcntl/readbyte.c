
#include <fcntl.h>


int readbyte(int fd) __z88dk_fastcall __naked
{
#asm
    INCLUDE "fcntl.def"
    ld      a,ESPCMD_READ
    call    __esp_send_cmd
    ld      a,l         ;fd
    call    __esp_send_byte
    ; Send length
    ld      a,1
    call    __esp_send_byte
    xor     a
    call    __esp_send_byte

    ; Read result - is fd valid
    call    __esp_read_byte
    and     a
    jr      z,not_failed
eof:
    ld      hl,-1
    scf
    ret
not_failed:
    ; Read length offered
    call    __esp_read_byte
    ld      c,a
    call    __esp_read_byte
    or      c
    jr      z,eof
    ; Read byte
    call    __esp_read_byte
    and     a
    ld      l,a
    ld      h,0
    ret
#endasm
}
