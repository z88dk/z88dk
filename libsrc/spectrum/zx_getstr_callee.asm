; 
;	ZX Spectrum specific routines 
;	by Stefano Bodrato, 22/06/2006 
;
;	Copy a variable from basic 
;
;	int __CALLEE__ zx_getstr_callee(char variable, char *value); 
;
;
;	$Id: zx_getstr_callee.asm,v 1.2 2007-10-18 10:12:40 stefano Exp $ 
;

XLIB	zx_getstr_callee
XDEF	ASMDISP_ZX_GETSTR_CALLEE

zx_getstr_callee:

	pop	bc
	pop	hl
	pop	de
	push	bc

; enter : hl = char *value
;          e = char variable

.asmentry

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

DEFC ASMDISP_ZX_GETSTR_CALLEE = asmentry - zx_getstr_callee

