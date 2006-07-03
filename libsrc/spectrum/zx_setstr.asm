;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 29/06/2006
;
;	Copy a string to a BASIC variable
;
;	int zx_setstr(char variable, char *value);
;
;
;	$Id: zx_setstr.asm,v 1.1 2006-07-03 15:04:15 stefano Exp $
;

	XLIB	zx_setstr
	
zx_setstr:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc
	
	ld	a,e
	and	95

	ld	(morevar+1),a
	ld	(pointer+1),hl
	

	ld	hl,($5c4b) 		; VARS
loop:	ld	a,(hl)
	cp	128
	jr	nz,morevar

	jr	store			; variable not found

morevar:
	cp	0
	jr	nz,nextvar
	
	call	$19b8			; get next variable start
	call	$19e8			; reclaim space (delete)
	
store:
	ld	bc,0
pointer:
	ld	de,0			; point to the string
	push	de
lenloop:
	inc	bc			; string length counter
	inc	de
	ld	a,(de)
	and	a
	jr	nz,lenloop

	push	hl
	push	bc
	inc	bc
	inc	bc
	inc	bc
	call	$1655		; MAKE-ROOM
	pop	bc
	pop	hl

	ld	a,(morevar+1)
	ld	(hl),a
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	pop	de
	
	ex	de,hl
	ldir	
	
	ret

nextvar:
	call	$19b8			;get next variable start
	ex	de,hl
	jr	loop
