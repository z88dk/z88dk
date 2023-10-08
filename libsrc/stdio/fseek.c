/*
 *    Get the position of a file
 *
 *    long ftell(FILE *fp)
 *
 *    Calls some machine dependent routine to do the dirty work
 *
 *    djm 1/4/2000
 *
 * --------
 * $Id: fseek.c,v 1.3 2016-03-06 12:12:57 dom Exp $
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>

static long fseek1(FILE *fp, fpos_t posn, int whence) __z88dk_callee;

int fseek(FILE *fp, fpos_t posn, int whence) __z88dk_saveframe
{
    if ( fp->flags&_IOUSE && fchkstd(fp)== 0 ) {
#if CPU_8080 || CPU_GBZ80
        if (lseek(fp->desc.fd,posn,whence) != -1L ) {
#else
        if (fseek1(fp,posn,whence) != -1L ) {
#endif
            fp->flags &= ~_IOEOF;
            return 0;
        }
    }
    return 1;
}

#asm
IF !__CPU_INTEL__ && !__CPU_GBZ80__
_fseek1:
    pop     af        ;return address
    pop     bc        ;whence
    pop     de        ;posn
    pop     hl
    pop     ix        ;fp
    push    af        ;return address

    ld      a,(ix+fp_flags)
    and    _IOEXTRA
    jr    nz, call_trampoline
; Normal file descriptor, just call lseek
    ld      a,c        ;save whence
    ld      bc,(ix+fp_desc)
    push    bc        ;descriptor
    push    hl        ;posn
    push    de
    ld      c,a
    ld      b,0
    push    bc        ;whence
    call    lseek
    pop     bc
    pop     bc
    pop     bc
    pop     bc
    ret

call_trampoline:
; Call via the trampoline
    ld      a,c        ;a = whence
    ld      c,l        ;lower 16 bit of posn
    ld      b,h
    ld      hl,(ix+fp_extra)
    ex      af,af
    ld      a,__STDIO_MSG_SEEK
    call    l_jphl
    ret
ENDIF
#endasm






    


