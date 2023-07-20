

#include <fcntl.h>


int remove(char *path) __smallc __naked
{
#asm
    INCLUDE "fcntl.def"
    EXTERN  asm_strlen

    ld      a,ESPCMD_DELETE
    call    __esp_send_cmd
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    push    hl
    call    asm_strlen
    ld      bc,hl
    inc     bc
    pop     hl
    call    __esp_send_bytes
    call    __esp_read_byte
    ld      l,a
    ld      h,0
    ret
#endasm
}