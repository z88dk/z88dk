;
;
;       Generic graphics routines
;       Self modifying code version
;
;       Stefano Bodrato - 4/1/2007
;
;
;       Sprite Rendering Routine
;       original code by Patrick Davidson (TI 85)
;
; 
;	$Id: putsprite_smc.asm,v 1.3 2016-07-02 09:01:35 dom Exp $
;


	PUBLIC    putsprite

	EXTERN	pixel
	EXTERN	pixmode


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

        ;inc     hl
        ld      a,(hl)  ; and/or/xor mode
        inc	hl
        ld	l,(hl)
        ld	h,a
        ld	(pixmode),hl

	ld	h,d
	ld	l,e
	
	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
.oloop	push	bc		;Save # of rows
	push	af

	;ld	b,a		;Load width
	ld	b,0		; Better, start from zero !!

	ld	c,(ix+2)	;Load one line of image

.iloop	sla	c		;Test leftmost pixel
	jr	nc,noplot	;See if a plot is needed

	pop	af
	push	af

	push	hl
	;push	bc	; this should be done by the called routine
	push	de
	ld	a,h
	add	a,b
	ld	h,a
	call	pixel
	pop	de
	;pop	bc
	pop	hl

.noplot

	inc	b	; witdh counter
	
	pop	af
	push	af
	
	cp	b		; end of row ?
	
	jr	nz,noblk
	
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	
	jr noblock
	
.noblk
	
	ld	a,b	; next byte in row ?
	;dec	a
	and	a
	jr	z,iloop
	and	7
	
	jr	nz,iloop
	
.block
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	jr	iloop

.noblock

	inc	l

	pop	af
	pop	bc		;Restore data
	djnz	oloop
	ret
