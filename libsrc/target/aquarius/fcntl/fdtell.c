

#include <stdio.h>


long fdtell(int fd) __naked
{
#asm
    INCLUDE "fcntl.def"
    EXTERN  asm_strlen

    ld      a,ESPCMD_TELL
    call    __esp_send_cmd
    ld      hl,2
    add     hl,sp
    ld      a,(hl)        ;fd
    call    __esp_send_byte
    call    __esp_read_byte
    and     a
    jr      z,continue
    ld      hl,-1
    ld      de,hl
    ret
continue:
    call    __esp_read_byte
    ld      l,a
    call    __esp_read_byte
    ld      h,a
    call    __esp_read_byte
    ld      e,a
    call    __esp_read_byte
    ld      d,a
    ret
#endasm
}
