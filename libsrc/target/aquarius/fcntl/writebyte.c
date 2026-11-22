
#include <fcntl.h>


int writebyte(int fd, int c) __smallc __naked
{
#asm
    INCLUDE "fcntl.def"
    ld      hl,4
    add     hl,sp

    ld      a,ESPCMD_WRITE
    call    __esp_send_cmd
    ld      a,(hl)
    call    __esp_send_byte
    dec     hl      ;sp+3
    dec     hl      ;sp+2
    ; Send length
    ld      a,1
    call    __esp_send_byte
    xor     a
    call    __esp_send_byte

    ld      a,(hl)  ;c
    call    __esp_send_byte

    ; Read result.  The ESP protocol returns a status byte first,
    ; followed by the number of bytes written on success.
    call    __esp_read_byte
    and     a
    jr      z,write_ok
    ld      hl,-1
    ret
write_ok:
    call    __esp_read_byte
    ld      l,a
    call    __esp_read_byte
    ld      h,a
    ret
#endasm
}
