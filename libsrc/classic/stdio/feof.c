/*
 *    Check for end of file
 *
 *    Return 1 = EOF 0 = not eof
 *
 *    djm 1/4/2000
 *
 * --------
 * $Id: feof.c,v 1.2 2001-04-13 14:13:58 stefano Exp $
 */

#define ANSI_STDIO
#define STDIO_ASM

#include <stdio.h>

static void wrapper() __naked
{
#asm
    GLOBAL    _feof
    GLOBAL    __feof
    GLOBAL    _feof_fastcall
feof:
_feof:
__feof:
    pop     de
    pop     hl
    push    hl
    push    de

feof_fastcall:
_feof_fastcall:
    inc     hl
    inc     hl    ;flags
    ld      a,(hl)
    ld      hl,1
IF __CPU_INTEL__
    and     @00001000
ELSE
    bit    3,a    ;_IOEOF
ENDIF
IF __CPU_GBZ80__
    jr      nz,feof_assign_ret
ELSE
    ret    nz
ENDIF
    dec     hl    ;hl = 0
IF __CPU_GBZ80__
feof_assign_ret:
    ld      d,h
    ld      e,l
ENDIF
    ret
#endasm
//    return (fp->flags&_IOEOF ? 1 : 0 );
}



