#include <fcntl.h>


int close(int fd) __smallc __naked
{
#asm
    INCLUDE "fcntl.def"

    ld      a,ESPCMD_CLOSE
    call    __esp_send_cmd
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    call    __esp_send_byte
    call    __esp_read_byte
    ld      l,a
    ld      h,0
    ret
#endasm
}