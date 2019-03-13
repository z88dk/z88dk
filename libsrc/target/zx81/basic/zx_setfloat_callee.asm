; 
;	ZX 81 specific routines 
;	by Stefano Bodrato, 28/06/2006 
; 
;	Copy a variable to basic 
; 
;	int __CALLEE__ zx_setfloat_callee(char *variable, float value); 
; 
;	$Id: zx_setfloat_callee.asm,v 1.6 2016-06-26 20:32:08 dom Exp $ 
;  	

SECTION code_clib
PUBLIC	zx_setfloat_callee
PUBLIC	_zx_setfloat_callee
PUBLIC 	ASMDISP_zx_setfloat_CALLEE

EXTERN	zx_locatenum
EXTERN	fa

zx_setfloat_callee:
_zx_setfloat_callee:

	pop hl	; ret addr
	
	pop de
	pop de
	pop de	; float value is already in FA
	
;	pop de     ; var name
	ex (sp),hl ; ret addr <-> var name

; enter : (FA) = float value
;         hl = char *variable

.asmentry

	;push	de
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
	ld	hl,($4014)      ; E_LINE
	dec	hl		; now HL points to end of VARS
IF FORlambda
	call	$1CB5
ELSE
	;;ld	hl,(16400)	; VARS
	call	$099E		; MAKE-ROOM
	;;call	$09A3		; MAKE-ROOM (no test on available space)
ENDIF
	inc	hl
	
	pop	de		; point to VAR name
	
	cp	6
	push	af

	ld	a,(de)
	cp	97		; ASCII Between a and z ?
	jr	c,isntlower
	sub	32		; Then transform in UPPER ASCII
.isntlower
	sub	27		; re-code to the ZX81 charset
	and	63
	ld	b,a

	pop	af
	ld	a,b
	jr	nz,morethan1
	or	96		; fall here if the variable name is
	ld	(hl),a		; only one char long
	inc	hl
	jr	store2

morethan1:
				; first letter of a long numeric variable name
	or	160		; has those odd bits added
	ld	(hl),a

lfloatlp:

	inc	de
	ld	a,(de)		; now we copy the body of the VAR name..
	and	a
	jr	z,endlfloat
	cp	97		; ASCII Between a and z ?
	jr	c,isntlower2
	sub	32		; Then transform in UPPER ASCII
.isntlower2
	sub	27		; re-code to the ZX81 charset

	inc	hl
	ld	(hl),a
	djnz	lfloatlp

endlfloat:

	ld	a,(hl) 
	or	128		; .. then we fix the last char
	ld	(hl),a 
	inc	hl
	jr	store2
	
store:

	pop	bc		; so we keep HL pointing just after the VAR name

store2:

	;pop	de
	
	; Store float value in VAR memory
	
	ld    de,fa+5
	ex    de,hl
	
	ld	b,5
.mvloop
	ld	a,(hl)
	ld	(de),a
	dec	hl
	inc	de
	djnz	mvloop
		
	ret
 
 DEFC ASMDISP_zx_setfloat_CALLEE = # asmentry - zx_setfloat_callee
 
