

#include <stdio.h>


int fdgetpos(int fd, fpos_t *dump)
{
#asm
    INCLUDE "fcntl.def"
    EXTERN  asm_strlen

    ld      a,ESPCMD_TELL
    call    __esp_send_cmd
    ld      hl,sp+4
    ld      a,(hl)        ;fd
    call    __esp_send_byte
    call    __esp_read_byte
    and     a
    jr      z,continue
    ld      hl,-1
    ret
continue:
    ld      hl,sp+2
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    call    __esp_read_byte
    ld      (hl),a
    call    __esp_read_byte
    ld      (hl),a
    call    __esp_read_byte
    ld      (hl),a
    call    __esp_read_byte
    ld      (hl),a
    ld      hl,0
    ret
#endasm
}
