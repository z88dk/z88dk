;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Sept 2003 - Stefano: Fixed bug for sprites wider than 8.
; Apr 2017  - Stefano: Fixed bug for sprite pos coordinates wider than 255.
;
; Much More Generic version
; Uses plotpixel, respixel and xorpixel
;
;
; $Id: w_putsprite2.asm,v 2017 Stefano Exp $
;

	SECTION code_clib
	PUBLIC    putsprite
   PUBLIC    _putsprite

	EXTERN	w_plotpixel
	EXTERN	w_respixel
	EXTERN	w_xorpixel

; __gfx_coords: h,l (vert-horz)
; sprite: (ix)

.putsprite
._putsprite

        ld      hl,2   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
	push	de
	pop	ix

        inc     hl
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)  ; x and y __gfx_coords
		ld		(oldx),bc

        inc     hl
        ld      a,(hl)  ; and/or/xor mode


	cp	166	; and(hl) opcode
	jr	z,doand

	cp	182	; or(hl) opcode
	jp	z,door

	; 182 - or
	; 174 - xor

;--------------------------------------
.doxor
	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
.oloopx
	push	bc		;Save # of rows
	push	af

	ld		hl,(oldx)	;;

	;ld	b,a		;Load width
	ld	b,0		; Better, start from zero !!

	ld	c,(ix+2)	;Load one line of image

.iloopx
	sla	c		;Test leftmost pixel
	jr	nc,noplotx	;See if a plot is needed

	push	hl
	push	bc
	push	de
	call	w_xorpixel	
	pop	de
	pop	bc
	pop	hl

.noplotx

	inc	b	; witdh counter
	inc hl ;;
	
	pop	af
	push	af
	
	cp	b		; end of row ?
	
	jr	nz,noblkx
	
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	
	jr noblockx
	
.noblkx
	
	ld	a,b	; next byte in row ?
	and	a
	jr	z,iloopx
	and	7
	
	jr	nz,iloopx
	
.blockx
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	jr	iloopx

.noblockx

	;pop hl
	;inc	l
	inc de

	pop	af
	pop	bc		;Restore data
	djnz	oloopx
	ret



;--------------------------------------
.doand
	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
.oloopa
	push	bc		;Save # of rows
	push	af

	ld		hl,(oldx)	;;

	;ld	b,a		;Load width
	ld	b,0		; Better, start from zero !!

	ld	c,(ix+2)	;Load one line of image

.iloopa
	sla	c		;Test leftmost pixel
	jr	nc,noplota	;See if a plot is needed

	push	hl
	push	bc
	push	de
	call	w_respixel
	pop	de
	pop	bc
	pop	hl

.noplota

	inc	b	; witdh counter
	inc hl ;;
	
	pop	af
	push	af
	
	cp	b		; end of row ?
	
	jr	nz,noblka
	
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	
	jr noblocka
	
.noblka
	
	ld	a,b	; next byte in row ?
	;dec	a
	and	a
	jr	z,iloopa
	and	7
	
	jr	nz,iloopa
	
.blocka
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	jr	iloopa

.noblocka

	;pop hl
	;inc	l
	inc de

	pop	af
	pop	bc		;Restore data
	djnz	oloopa
	ret



;--------------------------------------
.door
	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
.oloopo
	push	bc		;Save # of rows
	push	af

	ld		hl,(oldx)	;;

	;ld	b,a		;Load width
	ld	b,0		; Better, start from zero !!

	ld	c,(ix+2)	;Load one line of image

.iloopo
	sla	c		;Test leftmost pixel
	jr	nc,noploto	;See if a plot is needed

	push	hl
	push	bc
	push	de
	call	w_plotpixel
	pop	de
	pop	bc
	pop	hl

.noploto

	inc	b	; witdh counter
	inc hl ;;
	
	pop	af
	push	af
	
	cp	b		; end of row ?
	
	jr	nz,noblko
	
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	
	jr noblocko
	
.noblko
	
	ld	a,b	; next byte in row ?
	;dec	a
	and	a
	jr	z,iloopo
	and	7
	
	jr	nz,iloopo
	
.blocko
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	jr	iloopo

.noblocko

	;pop hl
	;inc	l
	inc de
	
	pop	af
	pop	bc		;Restore data
	djnz	oloopo
	ret


	SECTION  bss_clib
.oldx
         defw   0

