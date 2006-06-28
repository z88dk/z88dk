;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/06/2006
;
;	Copy a variable from basic
;
;	int zx_getstr(char variable, char *value);
;
;
;	$Id: zx_getstr.asm,v 1.1 2006-06-28 22:21:26 stefano Exp $
;

	XLIB	zx_getstr
	
zx_getstr:
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
	ld	hl,-1			; variable not found
	ret
morevar:
	cp	0
	jr	nz,nextvar

	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
pointer:
	ld	de,0
	ldir
	inc	de
	xor	a
	ld	(de),a
	
	ld	hl,0
	ret
nextvar:
	call	$19b8			;get next variable start
	ex	de,hl
	jr	loop
