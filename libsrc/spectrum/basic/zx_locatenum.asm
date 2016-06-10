;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 28/06/2006
;	Fixed by Antonio Schifano, Dec 2008
;
;	Locate the numeric variable having name pointed by HL
;	Internal routine used by zx_getint and zx_setint
;
;	Carry flag is set on error
;
;
;	$Id: zx_locatenum.asm,v 1.7 2016-06-10 20:02:04 dom Exp $
;
;	vars format:
;
;	single char name:	a fp5 (a lower case)
;	multi char name: 	a1+$40 a2 ... an|$80 v (ak lower case)
;	for single char name:	a|$80 v vt vs (a lower case)
;

SECTION code_clib
	PUBLIC	zx_locatenum
	PUBLIC	_zx_locatenum
	EXTERN	call_rom3
	
zx_locatenum:
_zx_locatenum:

	;ex	de,hl
	;ld	a,(de)
	
	ld	a,(hl)
	
	and	a
	jr	nz,notempty
	scf
	ret
notempty:
	or	32		; make it lower case
	ld	c,a		; keep the first letter

	push	hl
	inc	hl
	ld	a,(hl)
	and	a		; only 1 char for var name ?
	ld	hl,($5c4b)	; VARS
	jr	z,onechar
	ld	a,@00011111	; first letter of a long numeric variable name
	and	c		; has those odd bits added
	or	@10100000
	ld	c,a
	jr	vp

onechar:

	ld	a,@00011111	; first letter of a single char variable name
	and	c		; has those odd bits added
	or	@01100000
	ld	c,a

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
	call    call_rom3
	defw	$19b8		; find next variable
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
	or	@01100000
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
