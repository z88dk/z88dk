
#include <fcntl.h>


ssize_t write(int fd,void * ptr,size_t len) __smallc __naked
{
#asm
    INCLUDE "fcntl.def"
    ld      hl,6
    add     hl,sp

    ld      a,ESPCMD_WRITE
    call    __esp_send_cmd
    ld      a,(hl)
    call    __esp_send_byte
    dec     hl      ;sp+5
    dec     hl      ;sp+4
    dec     hl      ;sp+3
    dec     hl      ;sp+2
    ld      a,(hl)  ;length
    ld      c,a
    call    __esp_send_byte
    inc     hl      ;sp+3
    ld      a,(hl)
    ld      b,a
    call    __esp_send_byte
    inc     hl      ;sp+4
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a     ;hl=ptr
    call    __esp_send_bytes

    ; Read result
    call    __esp_read_byte
    ld      l,a
    call    __esp_read_byte
    ld      h,a
    ret
#endasm
}
