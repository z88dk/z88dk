/*
 *    Check for file errors
 *
 *    Return 1 = Error,  0 = Ok
 *
 *    Stefano Bodrato, Sep. 2019
 *
 * --------
 * $Id: ferror.c $
 */

#define ANSI_STDIO
#define STDIO_ASM

#include <stdio.h>

int wrapper2(FILE *fp) __naked
{
#asm
PUBLIC _ferror
PUBLIC __ferror
PUBLIC _ferror_fastcall
ferror:
_ferror:
__ferror:
    pop     de
    pop     hl
    push    hl
    push    de
ferror_fastcall:
_ferror_fastcall:
    inc     hl
    inc     hl    ;flags
    ld      a,(hl)
    ld      hl,1
    
    and     _IOUSE        ; in use?
    ret     z
    
; check EOF only if not WRITE mode
    and     _IOWRITE
    jr      nz,__ferror_skip_eof
    and     _IOEOF
    ret     nz
__ferror_skip_eof:
    dec     hl    ;hl = 0
    ret

#endasm
}
