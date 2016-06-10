; 
;	ZX Spectrum specific routines 
;	by Stefano Bodrato, 28/06/2006 
; 
;	Copy a variable from basic 
; 
;	int __CALLEE__ zx_setint_callee(char *variable, int value); 
; 
;	$Id: zx_setint_callee.asm,v 1.5 2016-06-10 20:02:04 dom Exp $ 
;  	

SECTION code_clib
PUBLIC	zx_setint_callee
PUBLIC	_zx_setint_callee
PUBLIC 	ASMDISP_ZX_SETINT_CALLEE
EXTERN	call_rom3

EXTERN	zx_locatenum

zx_setint_callee:
_zx_setint_callee:

	pop hl
	pop de
	ex (sp),hl

; enter : de = int value
;         hl = char *variable

.asmentry

	push	de
	push	hl
	call	zx_locatenum
	
	jr	nc,store
	
	; variable not found: create space for a new one
	
	pop	hl
	push	hl
	
	ld	c,0

vlcount:

	ld	a,(hl)
	inc	c
	and	a
	inc	hl
	jr	nz,vlcount
	
	dec	c
	ld	a,5		; 5 bytes + len of VAR name
	add	c
	ld	c,a
	
	ld	b,0
	ld	hl,($5c59)      ; E_LINE
	dec	hl		; now HL points to end of VARS
	call    call_rom3
	defw	$1655		; MAKE-ROOM
	inc	hl
	
	pop	de		; point to VAR name
	
	cp	6
	ld	a,(de)
	jr	nz,morethan1
	or	32		; fall here if the variable name is
	ld	(hl),a		; only one char long
	inc	hl
	jr	store2

morethan1:

	and	63		; first letter of a long numeric variable name
	or	160		; has those odd bits added
	ld	(hl),a

lintlp:

	inc	de
	ld	a,(de)		; now we copy the body of the VAR name..
	and	a
	jr	z,endlint
	or	32
	inc	hl
	ld	(hl),a
	djnz	lintlp

endlint:

	ld	a,(hl) 
	or	128		; .. then we fix the last char
	ld	(hl),a 
	inc	hl
	jr	store2
	
store:

	pop	bc		; so we keep HL pointing just after the VAR name

store2:

	pop	de
	
	; hint by Dom Morris, store integer directly in VAR memory
	
	ld    (hl),0
	inc   hl
	ld    (hl),0
	inc   hl
	ld    (hl),e
	inc   hl
	ld    (hl),d
	inc   hl
	ld    (hl),0
	
	ret
 
 DEFC ASMDISP_ZX_SETINT_CALLEE = # asmentry - zx_setint_callee
 
