/*
 *    fflush(fp)
 *
 *    Only really valid for TCP net connections
 *
 * --------
 * $Id: fflush.c,v 1.4 2016-03-06 21:36:52 dom Exp $
 */

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>


int fflush(FILE *fp)
{
#asm
IF __CPU_RABBIT__ | __CPU_KC160__
    ld      hl,(sp + 2)
ELSE
    pop     bc
    pop     hl
    push    hl
    push    bc
ENDIF
    ld      e,(hl)   ;fd
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)
    and     _IOUSE|_IOSYSTEM|_IOWRITE
    cp      _IOUSE|_IOWRITE
IF __CPU_INTEL__ | __CPU_GBZ80__ 
    jr      nz,fflush_error
ELSE
    jr      nz,check_extra
ENDIF
    push    de       ;fd
    call    fsync
    pop     bc       ;dump param
    ret
IF !__CPU_INTEL__ && !__CPU_GBZ80__
check_extra:
    ld      a,(hl)
    and     _IOUSE|_IOEXTRA
    cp      _IOUSE|_IOEXTRA
    jr      nz,fflush_error     ;not used
    push    ix    ;save callers ix
    dec     hl
    dec     hl    ;hl = fp
  IF __CPU_RABBIT__
    ld      ix,hl
  ELSE
    push    hl
    pop     ix
  ENDIF
    ld      hl,(ix+fp_extra)
    ld      a,__STDIO_MSG_FLUSH
    call    l_jphl
    pop     ix    ;restore callers
  IF __CPU_RABBIT__
    bool    hl
    rr    hl
  ELSE
    ld      hl,0
  ENDIF
    ret
ENDIF
.fflush_error
    ld      hl,-1    ; EOF
IF __CPU_GBZ80__
    ld      d,h
    ld      e,l
ENDIF
#endasm
}





