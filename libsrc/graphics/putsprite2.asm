;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Much More Generic version
; Uses plotpixel, respixel and xorpixel
;
;
; $Id: putsprite2.asm,v 1.3 2002-04-17 21:30:24 dom Exp $
;


	XLIB    putsprite

	LIB	plotpixel
	LIB	respixel
	LIB	xorpixel

; coords: h,l (vert-horz)
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
        ld      d,(hl)	; x and y coords

	inc	hl

        inc     hl
        ld      a,(hl)  ; and/or/xor mode

	ld	h,d
	ld	l,e
	
	cp	166	; and(hl) opcode
	jr	z,doand

	cp	182	; and(hl) opcode
	jr	z,door

	; 182 - or
	; 174 - xor

.doxor
	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
.oloopx	push	bc		;Save # of rows
	push	af

	ld	b,a		;Load width

	ld	c,(ix+2)	;Load one line of image
	inc	ix

.iloopx	sla	c		;Test leftmost pixel
	jr	nc,noplotx	;See if a plot is needed

	pop	af
	push	af

	push	hl
	;push	bc	; this should be done by the called routine
	push	de
	add	a,h
	sub	a,b
	ld	h,a
	call	xorpixel
	pop	de
	;pop	bc
	pop	hl

.noplotx

	pop	af
	push	af
	sub	b
	cp	7		; Are we at a byte edge ?
	jr	nz,noblockx
	pop	af
	push	af
	cp	8
	jr	z,noblockx	; Wasn't it the last bit ?

	ld	c,(ix+2)	;Load right part of image
	inc	ix

.noblockx

	djnz	iloopx
	inc	l
	pop	af
	pop	bc		;Restore data
	djnz	oloopx
	ret



.doand
	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
.oloopa	push	bc		;Save # of rows
	push	af

	ld	b,a		;Load width

	ld	c,(ix+2)	;Load one line of image
	inc	ix

.iloopa	sla	c		;Test leftmost pixel
	jr	nc,noplota	;See if a plot is needed

	pop	af
	push	af

	push	hl
	;push	bc	; this should be done by the called routine
	push	de
	add	a,h
	sub	a,b
	ld	h,a
	call	respixel
	pop	de
	;pop	bc
	pop	hl

.noplota

	pop	af
	push	af
	sub	b
	cp	7		; Are we at a byte edge ?
	jr	nz,noblocka
	pop	af
	push	af
	cp	8
	jr	z,noblocka	; Wasn't it the last bit ?

	ld	c,(ix+2)	;Load right part of image
	inc	ix

.noblocka

	djnz	iloopa
	inc	l
	pop	af
        pop	bc		;Restore data
        djnz    oloopa
        ret




.door
	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
.oloopo	push	bc		;Save # of rows
	push	af

	ld	b,a		;Load width

	ld	c,(ix+2)	;Load one line of image
	inc	ix

.iloopo	sla	c		;Test leftmost pixel
	jr	nc,noploto	;See if a plot is needed

	pop	af
	push	af

	push	hl
	;push	bc	; this should be done by the called routine
	push	de
	add	a,h
	sub	a,b
	ld	h,a
	call	plotpixel
	pop	de
	;pop	bc
	pop	hl

.noploto

	pop	af
	push	af
	sub	b
	cp	7		; Are we at a byte edge ?
	jr	nz,noblocko
	pop	af
	push	af
	cp	8
	jr	z,noblocko	; Wasn't it the last bit ?

	ld	c,(ix+2)	;Load right part of image
	inc	ix

.noblocko

	djnz	iloopo
	inc	l
	pop	af
	pop	bc		;Restore data
	djnz	oloopo
	ret

