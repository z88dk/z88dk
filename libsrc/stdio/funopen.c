
#define STDIO_ASM

#include <stdio.h>
#include <stdlib.h>

#asm
	SECTION code_clib
	PUBLIC	funopen
	PUBLIC	_funopen

; FILE  *funopen(const void	*cookie, int (*readfn)(void *, char *, int),
;	 int (*writefn)(void *,	const char *, int),
;	 fpos_t	(*seekfn)(void *, fpos_t, int),	int (*closefn)(void *));

DEFVARS 0 {
	fu_readfn		ds.w	1
	fu_writefn		ds.w	1
	fu_seekfn		ds.w	1
	fu_closefn		ds.w	1	
}


funopen:
_funopen:
	; Allocate some memory first of all
	push	ix		;save callers ix

	ld	ix,4
	add	ix,sp		;points to closefn

	ld	hl, +(fp_extra + 2) + ( fu_closefn + 2)
	push	hl
	call	malloc		
	pop	bc
	push	hl		;Keep for later
	ld	e,(ix+8)	;cookie
	ld	d,(ix+9)
	ld	(hl),e		;fp_desc
	inc	hl
	ld	(hl),d
	inc	hl
	ld	(hl),_IOUSE|_IOEXTRA|_IOREAD|_IOWRITE
	inc	hl
	ld	(hl),0		;ungetc
	inc	hl
	ld	de,funopen_trampoline
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ld	e,(ix + 6)	;readfn
	ld	d,(ix + 7)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ld	e,(ix + 4)	;writefn
	ld	d,(ix + 5)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ld	e,(ix + 2)	;seekfn
	ld	d,(ix + 3)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ld	e,(ix + 0)	;closefn
	ld	d,(ix + 1)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	pop	hl		;get fp back
	pop	ix		;restore callers
	ret
	
	

funopen_trampoline:
        cp      __STDIO_MSG_GETC
        jr      z,handle_getc
        cp      __STDIO_MSG_PUTC
        jr      z,handle_putc
        cp      __STDIO_MSG_READ
        jr      z,handle_read
        cp      __STDIO_MSG_WRITE
        jr      z,handle_write
        cp      __STDIO_MSG_SEEK
        jr      z,handle_seek
        cp      __STDIO_MSG_CLOSE
        jr      z,handle_close

handle_getc:
	push	hl	; storage space
	ld	hl,0
	add	hl,sp
	ex	de,hl	;de = buf
	ld	bc,1
	call	handle_read
handle_returncodes:
	pop	bc	; c = byte read (if any)
	ld	a,h
	or	l
	jr	z,eof
	inc	hl
	ld	a,h
	or	l
	jr	z,error
	; Successful return, return new character
	ld	l,c
	ld	h,0
	ret
eof:
error:
	scf
	ld	hl,EOF
	ret
	
; Entry: ix = fp
;        bc = character
; Exit: hl = result
handle_putc:
	push	bc
	ld	hl,0
	add	hl,sp
	ex	de,hl
	ld	bc,1
	call	handle_write
	pop	bc	; byte we wrote
	inc	hl
	ld	a,h
	or	l
	jr	z,eof
	; Successful return, return character written
	ld	l,c
	ld	h,0
	ret

; ix = fp
; de = buf,
; bc = length
handle_read:
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	hl
	push	de
	push	bc
	ld	l,(ix + fp_extra + 2 + fu_readfn)
	ld	h,(ix + fp_extra + 2 + fu_readfn + 1)
	call	l_jphl
	pop	bc
	pop	bc
	pop	bc
	ret

; ix = fp
; de = buf,
; bc = length	
handle_write:
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	hl
	push	de
	push	bc
	ld	l,(ix + fp_extra + 2 + fu_writefn)
	ld	h,(ix + fp_extra + 2 + fu_writefn + 1)
	call	l_jphl
	pop	bc
	pop	bc
	pop	bc
	ret


handle_seek:
        scf     ; error
        ret



handle_close:
	ld	l,(ix + fp_extra + 2 + fu_closefn)
	ld	h,(ix + fp_extra + 2 + fu_closefn + 1)
	ld	c,(ix + fp_desc)
	ld	b,(ix + fp_desc + 1)
	push	bc
	call	l_jphl		; call users close function
	pop	bc
	push	ix
	pop	hl
	call	free		; and free the descriptor
	pop	bc
	ret

			
#endasm

