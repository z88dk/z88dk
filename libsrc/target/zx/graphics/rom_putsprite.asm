;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; ZX Spectrum ROM version, a bit slower
;
;
; $Id: rom_putsprite.asm,v 1.4 2017-01-02 22:57:59 aralbrec Exp $
;

	PUBLIC    putsprite
   PUBLIC    _putsprite
	EXTERN	pixeladdress
	EXTERN	zx_saddrpdown

	EXTERN	romsvc

	INCLUDE	"graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


.offsets_table
         defb	128,64,32,16,8,4,2,1

.putsprite
._putsprite

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

	inc	hl

        inc     hl
        ld      a,(hl)  ; and/or/xor mode
        ld	(romsvc+1),a	; Self modifying code
        inc     hl
        ld      a,(hl)
        ld	(romsvc),a	; Self modifying code
        ld	a,201		; ret
        ld	(romsvc+2),a
        
	ld	a,d

	push	af
	ld	h,a
	ld	l,e
	call	pixeladdress	
	ld	h,d
	ld	l,e
	ld	(romsvc+3),hl	; store current row
	pop	af
	
	push	hl
	
        AND     @00000111

         ld       hl,offsets_table
         ld       c,a
         ld       b,0
         add      hl,bc
         ld       a,(hl)
         ld       (romsvc+5),a

	pop	hl

	ld	a,(ix+0)
	cp	9
	jr	nc,putspritew

	 di
         ld       d,(ix+0)
         ld       b,(ix+1)
._oloop  push     bc                ;Save # of rows
         ld       b,d               ;Load width
         ld       c,(ix+2)          ;Load one line of image
         inc      ix
         ld       a,(romsvc+5)               ;Load pixel mask
._iloop  sla      c                 ;Test leftmost pixel
         jr       nc,_noplot        ;See if a plot is needed
         ld       e,a
	
	call	romsvc

         ld       (hl),a
         ld       a,e
._noplot rrca
         jr       nc,_notedge       ;Test if edge of byte reached
         inc      hl                ;Go to next byte
._notedge djnz     _iloop

	; ---------
	ld	hl,(romsvc+3)	; current address
	call	zx_saddrpdown
	ld	(romsvc+3),hl
	; ---------

         pop      bc                ;Restore data
         djnz     _oloop
         ei
         ret


.putspritew
	 di
         ld       d,(ix+0)
         ld       b,(ix+1)        
.woloop  push     bc                ;Save # of rows
         ld       b,d               ;Load width
         ld       c,(ix+2)          ;Load one line of image
         inc      ix
         ld       a,(romsvc+5)               ;Load pixel mask
.wiloop  sla      c                 ;Test leftmost pixel
         jr       nc,wnoplot         ;See if a plot is needed
         ld       e,a

	call	romsvc

         ld       (hl),a
         ld       a,e
.wnoplot rrca
         jr       nc,wnotedge        ;Test if edge of byte reached
         inc      hl                ;Go to next byte
.wnotedge
	ld	e,a
	ld	a,(romsvc+5)               ;pixel mask
	cp	e
	ld	a,e
         jr       z,wover_1

         djnz     wiloop

	; ---------
	ld	hl,(romsvc+3)	; current address
	call	zx_saddrpdown
	ld	(romsvc+3),hl
	; ---------

         pop      bc                ;Restore data
         djnz     woloop
         ei
         ret

.wover_1 ld       c,(ix+2)
         inc      ix
         djnz     wiloop
         dec      ix

	; ---------
	ld	hl,(romsvc+3)	; current address
	call	zx_saddrpdown
	ld	(romsvc+3),hl
	; ---------

         pop      bc
         djnz     woloop
         ei
         ret

