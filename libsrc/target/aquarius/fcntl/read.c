
#include <fcntl.h>


ssize_t read(int fd,void * ptr,size_t len) __smallc __naked
{
#asm
    INCLUDE "fcntl.def"
    ld      hl,6
    add     hl,sp

    ld      a,ESPCMD_READ
    call    __esp_send_cmd
    ld      a,(hl)          ;fd
    call    __esp_send_byte
    dec     hl      ;sp+5
    dec     hl      ;sp+4
    dec     hl      ;sp+3
    dec     hl      ;sp+2
    ld      a,(hl)  ;length
    call    __esp_send_byte
    inc     hl      ;sp+3
    ld      a,(hl)
    call    __esp_send_byte

    ; Read result
    call    __esp_read_byte
    and     a
    jr      z,not_failed
    ld      hl,-1
    ret
not_failed:
    ; Read offered length
    call    __esp_read_byte
    ld      c,a
    call    __esp_read_byte
    ld      b,a
    push    bc
    inc     hl      ;sp+4
    ld      a,(hl)  ;ptr
    inc     hl
    ld      h,(hl)
    ld      l,a
    ; And fill buffer for offered length
loop:
    call    __esp_read_byte
    ld      (hl),a
    inc     hl
    dec     bc
    ld      a,b
    or      c
    jr      nz,loop
    pop     hl      ;amount read
    ret
#endasm
}
