/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: ungetc.c,v 1.4 2016-03-06 21:36:52 dom Exp $
 */

#define ANSI_STDIO

#define STDIO_ASM

#include <stdio.h>

int ungetc(int c, FILE *fp)
{
#ifdef __SCCZ80
#asm
    pop     hl      ;ret
    pop     de      ;fp
    pop     bc      ;c
    push    bc
    push    de
    push    hl
    ld      hl,-1   ;EOF
    inc     de
    inc     de      ;now on flags
    ld      a,(de)
    ld      b,a     ;b=flags
    and     a
    ret     z       ;not being used
    and     _IOEOF |_IOWRITE|_IOUNGETC
    ret     nz      ;cant push back after EOF (or for write stream)
    ld      a,b     ;indicate that we have a character ungot
    or      _IOUNGETC
    ld      (de),a
    inc     de      ;now on ungetc
    ex      de,hl
    ld      (hl),c  ;store the char
    ld      l,c     ;return it
    ld      h,0
IF __CPU_GBZ80__
    ld      d,h
    ld      e,l
ENDIF
#endasm
#else
    if (fp == 0 || c == EOF || fp->ungetc || fp->flags&(_IOEOF|_IOUNGETC|)IOWRITE ) return(EOF);
    
    fp->ungetc=(unsigned char)c;
    fp->flags |= _IOUNGETC;
    return(c);
#endif
}
