/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fclose.c,v 1.5 2016-03-13 22:22:39 dom Exp $
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>



int fclose(FILE *fp)
{
#asm
IF __CPU_RABBIT__ | __CPU_KC160__
    ld      hl,(sp + 2)
ELSE
    pop     de
    pop     hl
    push    hl
    push    de
ENDIF
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)
    and     _IOUSE        ;inuse?
    jr      nz, fclose_inuse
fclose_error:
    ld      hl,-1        ;EOF
    ret
fclose_inuse:
    ld      a,(hl)
    and     _IOSTRING
    jr      nz,fclose_success
IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_GBZ80__
    ld      a,(hl)
    and     _IOEXTRA
    jr      z,fclose_no_net
; We have to go via trampoline here
    push    hl    ;save flags pointer
    dec     hl
    dec     hl    ;hl = fp
    push    ix    ;Save callers ix
    push    hl
    pop     ix    ;ix = fp
    ld      hl,(ix+fp_extra)
    ld      a,__STDIO_MSG_CLOSE
    call    l_jphl
    pop     ix    ;restore callers ix
    jr      fclose_check_success
ENDIF
fclose_no_net:
    ld      a,(hl)
    and     _IOSYSTEM
    jr      nz, fclose_success

    push    hl    ; points to flags
    push    de
    call    close
    pop     bc    ;fd
fclose_check_success:
    pop     de    ;flags pointer
    ld      a,h    ; an error
    or    l
IF __CPU_GBZ80__
    jr      nz,fclose_assign_ret
ELSE
    ret    nz
ENDIF
    ex      de,hl
fclose_success:
    ld      de,0
    ld      (hl),e    ;flags
    dec     hl
    ld      (hl),e    ;descriptor + 1
    dec     hl
    ld      (hl),e
    ex      de,hl
IF __CPU_GBZ80__
fclose_assign_ret:
    ld      d,h
    ld      e,l
ENDIF
#endasm
}
