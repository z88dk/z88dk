;
; Getsprite - Picks up a sprite from display with the given size
; by Stefano Bodrato - Jan 2001
;
; The original putsprite code is by Patrick Davidson (TI 85)
;
; Generic version (just a bit slow)
;
;
; $Id: getsprite.asm,v 1.4 2002-04-11 10:42:49 stefano Exp $
;

	XLIB    getsprite
	LIB	pixeladdress

	INCLUDE	"graphics/grafix.inc"

; coords: d,e (vert-horz)
; sprite: (ix)


.actcoord
	 defw	0


.getsprite

        ld      hl,2   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ; sprite address
	push	de
	pop	ix

        inc     hl
        ld      e,(hl)  
 	inc	hl
        inc     hl
        ld      d,(hl)	; x and y coords

	ld	h,d
	ld	l,e

	ld	(actcoord),hl	; save current coordinates

	call	pixeladdress
	xor	7
	
	 ld       (_smc+1),a
	 
	ld	h,d
	ld	l,e

         ld       e,(ix+0)
         ld       b,(ix+1)

	dec	e
	srl	e
	srl	e
	srl	e
	inc	e		; INT ((width-1)/8+1)

._oloop	push	bc	;Save # of rows
	push	de	;Save # of bytes per row

._iloop2	ld	c,(hl)
		ld	a,c	;keep it for the jump to zpos
._smc		ld	b,1	;Load pixel position
		inc	b
		dec	b
		jr	z,zpos
		inc	hl
		ld	d,(hl)

._iloop
		rl	d
		rl	c
		djnz	_iloop
		
		ld	a,c

.zpos
		ld	(ix+2),a
		inc	ix
		
		dec	e
		jr	nz,_iloop2

	; ---------
	push	de
        ld	hl,(actcoord)
	inc	l
	ld	(actcoord),hl
	call	pixeladdress
	ld	h,d
	ld	l,e
	pop	de
	; ---------

	pop	de
	pop	bc                ;Restore data
	djnz	_oloop
	ret

