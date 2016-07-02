;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Sept 2003 - Stefano: Fixed bug for sprites wider than 8.
;
; Much More Generic version
; Uses plotpixel, respixel and xorpixel
;
; ** putsprite3 is a thin version with a Self Modifying Code trick **
;
;
; $Id: putsprite3.asm,v 1.3 2016-07-02 09:01:35 dom Exp $
;


	PUBLIC    putsprite

	EXTERN	plotpixel
	EXTERN	respixel
	EXTERN	xorpixel

; __gfx_coords: h,l (vert-horz)
; sprite: (ix)

.putsprite

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

	inc	hl

        inc     hl
        ld      a,(hl)  ; and/or/xor mode

	cp	166	; and(hl) opcode
	jr	nz,nodoand
	ld	hl,respixel
	ld	(called+1),hl
	jr	doxor
.nodoand

	cp	182	; or(hl) opcode
	jr	nz,nodoor
	ld	hl,plotpixel
	ld	(called+1),hl
	jr	doxor

	; 182 - or
	; 174 - xor

.nodoor
	ld	hl,xorpixel
	ld	(called+1),hl

.doxor
	ld	h,d
	ld	l,e

	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
.oloopx	push	bc		;Save # of rows
	push	af

	;ld	b,a		;Load width
	ld	b,0		; Better, start from zero !!

	ld	c,(ix+2)	;Load one line of image

.iloopx	sla	c		;Test leftmost pixel
	jr	nc,noplotx	;See if a plot is needed

	pop	af
	push	af

	push	hl
	;push	bc	; this should be done by the called routine
	push	de
	ld	a,h
	add	a,b
	ld	h,a
.called
	call	xorpixel
	pop	de
	;pop	bc
	pop	hl

.noplotx

	inc	b	; witdh counter
	
	pop	af
	push	af
	
	cp	b		; end of row ?
	
	jr	nz,noblkx
	
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	
	jr noblockx
	
.noblkx
	
	ld	a,b	; next byte in row ?
	;dec	a
	and	a
	jr	z,iloopx
	and	7
	
	jr	nz,iloopx
	
.blockx
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	jr	iloopx

.noblockx

	inc	l

	pop	af
	pop	bc		;Restore data
	djnz	oloopx
	ret

