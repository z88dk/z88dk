;
;	Fast background area save
;
;	MSX version
;
;	$Id: bksave.asm,v 1.7 2016-07-02 09:01:36 dom Exp $
;

	SECTION   code_clib
	PUBLIC    bksave
	PUBLIC    _bksave
	PUBLIC	bkpixeladdress


IF FORmsx
	INCLUDE "msx.def"
ELSE
	INCLUDE "svi.def"
ENDIF

	
.bksave
._bksave
	push	ix	;save callers
        ld      hl,2   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
	push	de
	pop	ix

        inc     hl
        ld      e,(hl)  
 	inc	hl
        inc     hl
        ld      d,(hl)	; x and y __gfx_coords

	ld	h,d	; current x coordinate
	ld	l,e	; current y coordinate

	ld	(ix+2),h
	ld	(ix+3),l

	ld	a,(ix+0)
	ld	b,(ix+1)

	dec	a
	srl	a
	srl	a
	srl	a
	inc	a
	inc	a		; INT ((Xsize-1)/8+2)
	ld	(rbytes+1),a

.bksaves
	push	bc

	push	hl
	call	bkpixeladdress
	pop	hl
	
.rbytes
	ld	b,0
.rloop
;-------
	ld	a,e		; LSB of video memory ptr
	di
	out	(VDP_CMD), a
	ld	a,d		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	ei
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)
;-------	
	ld	(ix+4),a
	
	;inc	de

	push	hl		; Point to next byte
	ld	hl,8
	add	hl,de
	ex	de,hl
	pop	hl

	inc	ix
	djnz	rloop


	inc	l
	
	pop	bc
	djnz	bksaves
	pop	ix		;restore callers
	ret




.bkpixeladdress
	push	hl
	ld	b,l		; Y
	
	ld	a,h		; X
	and	@11111000
	ld	l,a

	ld	a,b		; Y
	rra
	rra
	rra
	and	@00011111

	ld	h,a		; + ((Y & @11111000) << 5)

	ld	a,b		; Y
	and	7
	ld	e,a
	ld	d,0
	add	hl,de		; + Y&7
	ex	de,hl
	pop	hl
	ret

