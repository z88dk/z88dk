; 
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Copy a variable from basic 
;
;	int __CALLEE__ zx_getstr_callee(char variable, char *value); 
;
;
;	$Id: zx_getstr_callee.asm,v 1.1 2008-07-25 15:31:25 stefano Exp $
;

XLIB	zx_getstr_callee
XDEF	ASMDISP_ZX_GETSTR_CALLEE
LIB	zx81toasc

zx_getstr_callee:

	pop	bc
	pop	hl
	pop	de
	push	bc

; enter : hl = char *value
;          e = char variable

.asmentry

	ld	a,e
	
	and	31
	add	69
	
	ld	(morevar+1),a
	ld	(pointer+1),hl
	
	ld	hl,($4010) 		; VARS
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
;-----------------------------
.outloop
	call	zx81toasc
	ld	(de),a
	inc	hl
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,outloop
;------------------------------
;	ldir
	inc	de
	xor	a
	ld	(de),a
	
	ld	hl,0
	ret
nextvar:
	call	$09F2			;get next variable start
	ex	de,hl
	jr	loop

DEFC ASMDISP_ZX_GETSTR_CALLEE = asmentry - zx_getstr_callee

