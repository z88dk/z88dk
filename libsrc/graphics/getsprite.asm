;
; Getsprite - Picks up a sprite from display with the given size
; original putsprite code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Generic version (just a bit slow)
;

	XLIB    getsprite
	LIB	pixeladdress

	INCLUDE	"graphics/grafix.inc"

; coords: d,e (vert-horz)
; sprite: (ix)


.offsets_table
        defb	128,64,32,16,8,4,2,1
	;defb	1,2,3,4,16,32,64,128
	
.actcoord
	 defw	0


.getsprite

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

	ld	h,d
	ld	l,e

	ld	(actcoord),hl	; save current coordinates

	call	pixeladdress
	xor	7

         ld       hl,offsets_table
         ld       c,a
         ld       b,0
         add      hl,bc
         ld       a,(hl)
         ld       (wsmc1+1),a
         ld       (wsmc2+1),a
	 ld       (_smc1+1),a
	ld	h,d
	ld	l,e

	ld	a,(ix+0)
	cp	9
	jr	nc,getspritew

         ld       d,(ix+0)
         ld       b,(ix+1)
._oloop  push     bc                ;Save # of rows
         ld       b,d               ;Load width

; Changes by Stefano
; we do a get-sprite

		ld	c,(hl)
._smc1		ld	a,1	;Load pixel mask
._iloop		sla	c
		rrca
		jr	c,_theedge	;Test if edge of byte reached
		djnz	_iloop
._theedge	ld	a,c
		inc	hl
		ld	c,(hl)
._iloop2	sra	c
		djnz	_iloop2
		or	c
		ld	(ix+2),a
		inc	ix

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

         pop      bc                ;Restore data
         djnz     _oloop
         ret


.getspritew
         ld       d,(ix+0)
         ld       b,(ix+1)        
.woloop  push     bc                ;Save # of rows
         ld       b,d               ;Load width

;oooooooooooooooooooooooooooooooooooooooo

         ld       c,(ix+2)          ;Load one line of image
         inc      ix
.wsmc1    ld       a,1               ;Load pixel mask
.wiloop  sla      c                 ;Test leftmost pixel
         jr       nc,wnoplot         ;See if a plot is needed
         ld       e,a

.ortype2
	nop	; changed into nop / cpl
         nop	; changed into and/or/xor (hl)
         ld       (hl),a
         ld       a,e
.wnoplot rrca
         jr       nc,wnotedge        ;Test if edge of byte reached
         inc      hl                ;Go to next byte
.wnotedge
.wsmc2   cp       1
         jr       z,wover_1

         djnz     wiloop

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

         pop      bc                ;Restore data
         djnz     woloop
         ret

.wover_1 ld       c,(ix+2)
         inc      ix
         djnz     wiloop
         dec      ix

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

         pop      bc
         djnz     woloop
         ret

