/*
 *	Get the position of a file
 *
 *	long ftell(FILE *fp)
 *
 *	Calls some machine dependent routine to do the dirty work
 *
 *	djm 1/4/2000
 *
 * --------
 * $Id: ftell.c,v 1.4 2016-03-06 21:36:52 dom Exp $
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>

fpos_t ftell(FILE *fp)
{
#ifdef Z80
#asm
	pop	bc
	pop	hl
	push	hl
	push	bc
IF !__CPU_INTEL__ && !__CPU_GBZ80__
        push    ix      ;save callers ix
ENDIF
	ld	e,(hl)	;gets the underlying fp
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)	; flags
	and	_IOUSE
	jr	z,ftell_abort
	ld	a,(hl)
	and	_IOSYSTEM
	jr	nz,ftell_abort
IF !__CPU_INTEL__ && !__CPU_GBZ80__
	ld	a,(hl)
	and	_IOEXTRA
	jr	nz,ftell_trampoline
ENDIF
	push	de
	call	fdtell
	pop	bc
IF !__CPU_INTEL__ && !__CPU_GBZ80__
        pop     ix
ENDIF
	ret
.ftell_abort
	ld	de,65535	;-1
	ld	l,e
	ld	h,d
IF !__CPU_INTEL__ && !__CPU_GBZ80__
        pop     ix
	ret

.ftell_trampoline
	; Call the seek function via the trampoline
	dec	hl
	dec	hl
  IF __CPU_R2KA__ | __CPU_R3K__
	ld	ix,hl
  ELSE
	push	hl
	pop	ix	;ix = fp
  ENDIF
	ld	de,0	;posn
	ld	bc,0
	ld	a,SEEK_CUR
	ex	af,af
  IF __CPU_R2KA__ | __CPU_R3K__
	ld	hl,(ix+fp_extra)
  ELSE
	ld	l,(ix+fp_extra)
	ld	h,(ix+fp_extra+1)
  ENDIF
	ld	a,__STDIO_MSG_SEEK
	call	l_jphl
	pop	ix
ENDIF
#endasm
#else
	if ( fp->flags&_IOUSE && fchkstd(fp)== 0 ) {
		return (fdtell(fp->fd));
	}
	return -1L;
#endif
}


