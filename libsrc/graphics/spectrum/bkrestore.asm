;
;	Fast background restore
;
;	ZX Spectrum version (speeded up with a row table)
;
;	$Id: bkrestore.asm,v 1.1 2002-02-27 13:12:26 stefano Exp $
;


	XLIB    bkrestore
	LIB	zx_rowtab


.bkrestore

        ld      hl,2   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
	push	de
	pop	ix
	
	ld	d,(ix+2)
	ld	e,(ix+3)
	
	ld	a,d
	ld	d,0
	
	ld	hl,zx_rowtab
	add	hl,de
	add	hl,de
	ld	(actrow+1),hl	; save row table position
	ld	(actrow1+1),hl
	
	ld	e,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,e
	
	push	af
	srl	a
	srl	a
	srl	a
	ld	(actcol+1),a
	ld	(actcol1+1),a
	ld	e,a
	pop	af

	add	hl,de
	
	ld	a,(ix+0)
	ld	b,(ix+1)
	cp	9
	jr	nc,bkrestorew

.bkrestores
	di
	push	bc
	ld	a,(ix+4)
	ld	(hl),a
	inc	hl
	ld	a,(ix+5)
	ld	(hl),a
	inc	ix
	inc	ix

	; ---------
.actrow
	ld	hl,0
	inc	hl
	inc	hl
	ld	(actrow+1),hl
	
	ld	b,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,b
.actcol
	ld	bc,0
	add	hl,bc
	; ---------

	pop	bc
	djnz	bkrestores
	ei
	ret

.bkrestorew
	di
	push	bc
	ld	a,(ix+4)
	ld	(hl),a
	inc	hl
	ld	a,(ix+5)
	ld	(hl),a
	inc	hl
	ld	a,(ix+6)
	ld	(hl),a
	inc	ix
	inc	ix
	inc	ix

	; ---------
.actrow1
	ld	hl,0
	inc	hl
	inc	hl
	ld	(actrow1+1),hl
	
	ld	b,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,b
.actcol1
	ld	bc,0
	add	hl,bc
	; ---------
	
	pop	bc
	djnz	bkrestorew
	ei
	ret
