;
; Getsprite - Picks up a sprite from display with the given size
; by Stefano Bodrato - Jan 2001
; Apr 2002 - Fixed.  (Long time, I know...)
;
; The original putsprite code is by Patrick Davidson (TI 85)
;
; Generic version (just a bit slow)
;
;
; $Id: getsprite.asm,v 1.9 2016-07-02 09:01:35 dom Exp $
;


                SECTION         code_clib
	PUBLIC    getsprite
	PUBLIC    _getsprite
	EXTERN	pixeladdress
	EXTERN     swapgfxbk
        EXTERN	__graphics_end

	INCLUDE	"graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)




.getsprite
._getsprite
	push	ix

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
        ld      d,(hl)	; x and y __gfx_coords

	ld	h,d
	ld	l,e

	ld	(actcoord),hl	; save current coordinates

	call	swapgfxbk
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

._iloop2	ld	a,(hl)
		inc	hl
		ld	d,(hl)

._smc		ld	b,1	;Load pixel position
		inc	b
		dec	b
		jr	z,zpos

._iloop
		rl	d
		rl	a
		djnz	_iloop

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
	
	jp	__graphics_end

                SECTION         bss_clib
.actcoord
	 defw	0
