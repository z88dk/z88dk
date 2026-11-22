



#include <fcntl.h>

// #define O_APPEND  256
// #define O_TRUNC   512
// #define O_CREAT   1024

// defc OPENF_APPEND  = 0x04 ; Append mode
// defc OPENF_CREATE  = 0x08 ; Create if non-existant
// defc OPENF_TRUNC   = 0x10 ; Truncate to zero length
// defc OPENF_EXCL    = 0x20 ; Error if already exists

int open(char *name, int flags, mode_t mode) __smallc __naked
{
#asm
    INCLUDE "fcntl.def"
    EXTERN  asm_strlen

    ld      a,ESPCMD_OPEN
    call    __esp_send_cmd
    ld      hl,5
    add     hl,sp
    xor     a
    bit     0,(hl)
    jr      z,not_append
    or      4
not_append:
    bit     1,(hl)
    jr      z,not_trunc
    or      16
not_trunc:
    bit     2,(hl)
    jr      z,not_creat
    or      8
not_creat:
    dec     hl
    or      (hl)
    call    __esp_send_byte
    inc     hl
    inc     hl
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
