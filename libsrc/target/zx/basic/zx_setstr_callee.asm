;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 29/06/2006
;	Fixed by Antonio Schifano, Dec 2008
;	
;	Copy a string to a BASIC variable
;
;	int __CALLEE__ zx_setstr_callee(char variable, char *value);
;
;	CPIR, debugged version by Antonio Schifano, 29/12/2008
;
;	$Id: zx_setstr_callee.asm $
;

SECTION code_clib
PUBLIC	zx_setstr_callee
PUBLIC	_zx_setstr_callee
PUBLIC	asm_zx_setstr
EXTERN	call_rom3

zx_setstr_callee:
_zx_setstr_callee:

	pop	bc
	pop	hl
	pop	de
	push	bc

; enter : hl = char *value
;          e = char variable

.asm_zx_setstr
	push	ix		;save callers ix - rom may corrupt it	
	ld	a,e
	and	95
	ld	d,a
	push	hl
	push	de

	ld	hl,($5c4b) 		; VARS
	
loop:

	ld	a,(hl)
	cp	128
	
	jr	z,store			; variable not found
	
morevar:

	cp	d
	jr	z,found

	call    call_rom3
IF FORts2068
	defw	$1720		; NEXT-ONE (find next variable)
ELSE
	defw	$19b8		; find next variable
ENDIF
	ex	de,hl
	pop	de
	push	de
	jr	loop

found:
	call    call_rom3
IF FORts2068
	defw	$1720		; NEXT-ONE (find next variable)
ELSE
	defw	$19b8		; find next variable
ENDIF
IF FORts2068
	call	$1750		; RECLAIM-2: reclaim space (delete)
ELSE
	call    call_rom3
	defw	$19e8			; reclaim space (delete)
ENDIF


store:

	pop	af			; swap var name and str. ptr into stack
	pop	de
	push	af
	push	de
	xor	a
	ld	b,a
	ld	c,a
	ex	de,hl
	cpir				; scan for zero
	ex	de,hl

	ld	a,b
	cpl
	ld	b,a
	ld	a,c
	cpl
	ld	c,a			; bc=str len
	
	push	hl
	push	bc
	inc	bc
	inc	bc
	inc	bc
IF FORts2068
	call	$12BB		; MAKE-ROOM
ELSE
	call    call_rom3
	defw	$1655		; MAKE-ROOM
ENDIF
	pop	bc
	pop	hl
	
	pop	de			; get back str. ptr
	pop	af			; and var name
	ld	(hl),a
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),b
	pop	ix			; restore callers ix
	ld	a,b			; handle 0 lenght strings
	or	c
	ret	z
	inc	hl
	
	ex	de,hl
	ldir
	
	ret
	

