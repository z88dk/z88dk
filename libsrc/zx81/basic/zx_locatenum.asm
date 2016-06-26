;
;	ZX 81 specific routines
;	by Stefano Bodrato, 28/07/2008
;
;	Locate the numeric variable having name pointed by HL
;	Internal routine used by zx_getint and zx_setint
;
;	Carry flag is set on error
;
;
;	$Id: zx_locatenum.asm,v 1.6 2016-06-26 20:32:08 dom Exp $
;

        SECTION code_clib
	PUBLIC	zx_locatenum
	PUBLIC	_zx_locatenum

zx_locatenum:
_zx_locatenum:

	ld	a,(hl)
	
	and	a
	jr	nz,notempty
	scf
	ret
notempty:
	and	31
	add	101

	ld	c,a		; keep the first letter
	
	push	hl
	inc	hl
	ld	a,(hl)
	and	a		; only 1 char for var name ?
	ld	hl,($4010)	; VARS
	jr	z,onechar
	ld	a,@00011111	; first letter of a long numeric variable name
	and	c		; has those odd bits added
	or	@10100000
	ld	c,a
onechar:
	
vp:	ld	a,(hl)
	cp	128
	jr	z,notfound

	cp	c
	jr	z,v2
	xor	128		; modify the var name format
	cp	c		; to see if it is a FOR-NEXT type var
	jr	z,v2
	;xor	128		; restore the original value
	ld	a,(hl)
	
v1:	push	bc
IF FORlambda
	call	$1A13
ELSE
	call	$09F2			; find next variable
ENDIF
	pop	bc
	ex	de,hl
	jr	vp

v2:	and	@11100000
	cp	@10100000
	jr	nz,result
	
	pop	de
	push	de
	push	hl

v3:	inc	hl
	inc	de
	ld	a,(de)

	cp	97	; ASCII Between a and z ?
	jr	c,isntlower
	sub	32	; Then transform in UPPER ASCII
.isntlower
	sub	27	; re-code to the ZX81 charset

	ld	b,a

	inc	de		; if this is the last character in the
	ld	a,(de)		; variable name, then...
	dec	de
	and	a
	ld	a,b
	jr	nz,noterminate
	add	128		; ...add the ZX style string terminator
noterminate:
	
	cp	(hl)
	jr	nz,v4
	
	rla
	jr	nc,v3
	inc	de
	ld	a,(de)
	dec	de
	and	a
	jr	nz,v3
	
	pop	de
	jr	result

v4:	pop	hl
	jr	v1

result:
	inc	hl
	pop	de
	and	a
	ret

notfound:
	pop	de
	scf
	ret
