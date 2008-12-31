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
;	$Id: zx_locatenum.asm,v 1.2 2008-12-31 13:58:11 stefano Exp $
;
;	vars format:
;
;	single char name:	a fp5 (a lower case)
;	multi char name: 	a1+$40 a2 ... an|$80 v (ak lower case)
;	for single char name:	a|$80 v vt vs (a lower case)

	XLIB	zx_locatenum
	
zx_locatenum:

	ex	de,hl
	ld	a,(de)
	
	and	a
	scf
	ret	z		; Return with carry set if Z

	or	32		; make it lower case
	ld	c,a		; keep the first letter
	
	push	hl
	inc	hl
	ld	a,(hl)
	and	a		; only 1 char for var name ?
	jr	z,onechar
	ld	a,63		; first letter of a long numeric variable name
	and	c		; has those odd bits added
	or	160		
	ld	c,a
onechar:
	ld	hl,($5c4b)
	
vp:	ld	a,(hl)
	cp	128
	jr	z,notfound

	cp	c
	jr	z,v2
	
v1:	push	bc
	call	$19b8		; find next variable
	pop	bc
	ex	de,hl
	jr	vp

v2:	and	224
	cp	160
	jr	nz,result
	
	pop	de
	push	de
	push	hl

v3:	inc	hl
	inc	de
	ld	a,(de)
	or	96
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
