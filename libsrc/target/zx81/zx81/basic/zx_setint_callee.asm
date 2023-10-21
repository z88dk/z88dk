; 
;	ZX 81 specific routines 
;	by Stefano Bodrato, 29/07/2008
; 
;	Copy a variable from basic 
; 
;	int __CALLEE__ zx_setint_callee(char *variable, int value); 
; 
;	$Id: zx_setint_callee.asm $
;  	

SECTION code_clib
PUBLIC	zx_setint_callee
PUBLIC	_zx_setint_callee
PUBLIC 	asm_zx_setint

EXTERN	zx_locatenum

IF FORlambda
	INCLUDE  "target/lambda/def/lambdafp.def"
ELSE
	INCLUDE  "target/zx81/def/81fp.def"
ENDIF

zx_setint_callee:
_zx_setint_callee:

	pop hl
	pop de
	ex (sp),hl

; enter : de = int value
;         hl = char *variable

.asm_zx_setint

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
	ld	hl,($4014)      ; E_LINE
	dec	hl		; now HL points to end of VARS
IF FORlambda
	EXTERN  __lambda_make_room
	call    __lambda_make_room
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

lintlp:

	inc	de
	ld	a,(de)		; now we copy the body of the VAR name..
	and	a
	jr	z,endlint
	cp	97		; ASCII Between a and z ?
	jr	c,isntlower2
	sub	32		; Then transform in UPPER ASCII
.isntlower2
	sub	27		; re-code to the ZX81 charset

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

	pop	bc
	push	hl			; save pointer to variable value
IF FORlambda
	EXTERN  __lambda_stack_bc
	call    __lambda_stack_bc
	ld de,(401Ch)		; STKEND
	ld hl,-5
	add hl,de
ELSE
	call  ZXFP_STACK_BC
	rst   ZXFP_BEGIN_CALC
	defb  ZXFP_END_CALC		; Now HL points to the float on the FP stack
ENDIF
	ld	(ZXFP_STK_PTR),hl	; update the FP stack pointer (equalise)
	pop	de			; restore pointer to variable value
	ld	bc,5
	ldir				; copy variable data
	
	ret
 
 
