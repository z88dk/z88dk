/*
 *	Get the position of a file
 *
 *	int fgetpos(FILE *fp, fpos_t *posn)
 *
 *	Calls some machine dependent routine to do the dirty work
 *
 *	djm 1/4/2000
 *
 * --------
 * $Id: fgetpos.c,v 1.4 2016-03-06 21:36:52 dom Exp $
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>

int fgetpos(FILE *fp, fpos_t *posn)
{
#ifdef Z80
#asm
IF __CPU_GBZ80__ | __CPU_INTEL__
	ld	hl,sp+2
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	a,(hl+)
	inc	hl
	ld	h,(hl)
	ld	l,a
ELSE
	pop	af	;ret
	pop	bc	;&posn
	pop	hl	;fp
	push	hl
	push	bc
	push	af	
ENDIF

IF !__CPU_INTEL__ && !__CPU_GBZ80__
        push    ix      ;save callers ix
ENDIF
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)	;flags
	and	_IOUSE
	jr	z,fgetpos_abort
	and	_IOSYSTEM
	jr	nz,fgetpos_abort
IF !__CPU_INTEL__ && !__CPU_GBZ80__
	ld	a,(hl)
	and	_IOEXTRA
	jr	nz,fgetpos_trampoline
ENDIF
	push	de	;fd
	push	bc	;&posn
	call	fdgetpos
	pop	bc
	pop	bc
IF !__CPU_INTEL__ && !__CPU_GBZ80__
        pop     ix
ENDIF
	ret
.fgetpos_abort
IF !__CPU_INTEL__ && !__CPU_GBZ80__
        pop     ix
ENDIF
	ld	hl,-1
	ret

IF !__CPU_INTEL__ && !__CPU_GBZ80__
.fgetpos_trampoline
	; Call the seek function via the trampoline
	dec	hl
	dec	hl
  IF __CPU_R2KA__ | __CPU_R3K__
	ld	ix,hl
  ELSE
	push	hl
	pop	ix	;ix = fp
  ENDIF
	push bc	; keep variable ptr for &posn result
	ld	de,0	;posn for lseek()
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
	pop	bc	;&posn
	call	l_plong
	pop	ix
ENDIF

#endasm
#else
	if ( fp->flags&_IOUSE && fchkstd(fp)== 0 ) {
		return (fdgetpos(fp->fd,posn));
	}
	return -1;
#endif
}


