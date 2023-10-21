; 
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Copy a variable from basic 
;
;	int __CALLEE__ zx_getstr_callee(char variable, char *value); 
;
;
;	$Id: zx_getstr_callee.asm $
;

SECTION code_clib
PUBLIC	zx_getstr_callee
PUBLIC	_zx_getstr_callee
PUBLIC	asm_zx_getstr
EXTERN	zx81toasc

zx_getstr_callee:
_zx_getstr_callee:

	pop	bc
	pop	hl
	pop	de
	push	bc

; enter : hl = char *value
;          e = char variable

.asm_zx_getstr

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
	xor	a
	ld	(de),a
	
	ld	hl,0
	ret

nextvar:
IF FORlambda
	EXTERN  __lambda_next_one
	call    __lambda_next_one
ELSE
	call	$09F2			;get next variable start
ENDIF
	ex	de,hl
	jr	loop

