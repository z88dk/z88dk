;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; ZX Spectrum version (speeded up with a row table)
;
;
; $Id: putsprite.asm,v 1.2 2002-03-18 10:35:55 stefano Exp $
;

	XLIB    putsprite
	LIB	zx_rowtab

	INCLUDE	"graphics/grafix.inc"

; coords: d,e (vert-horz)
; sprite: (ix)


.offsets_table
         defb	128,64,32,16,8,4,2,1

.putsprite

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

	inc	hl

        inc     hl
        ld      a,(hl)  ; and/or/xor mode
        ld	(ortype+1),a	; Self modifying code
        ld	(ortype2+1),a	; Self modifying code

        inc     hl
        ld      a,(hl)
        ld	(ortype),a	; Self modifying code
        ld	(ortype2),a	; Self modifying code

	ld	a,d
	ld	d,0
	
	ld	hl,zx_rowtab
	add	hl,de
	add	hl,de
	ld	(actrow+1),hl	; save row table position
	ld	(actrow1+1),hl
	ld	(actrow2+1),hl

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
	ld	(actcol2+1),a
	ld	e,a
	pop	af

	add	hl,de
	
	push	hl
	
        AND     @00000111

         ld       hl,offsets_table
         ld       c,a
         ld       b,0
         add      hl,bc
         ld       a,(hl)
         ld       (wsmc1+1),a
         ld       (wsmc2+1),a
	 ld       (_smc1+1),a

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
._smc1   ld       a,1               ;Load pixel mask
._iloop  sla      c                 ;Test leftmost pixel
         jr       nc,_noplot        ;See if a plot is needed
         ld       e,a

.ortype
	nop	; changed into nop / cpl
         nop	; changed into and/or/xor (hl)
         ld       (hl),a
         ld       a,e
._noplot rrca
         jr       nc,_notedge       ;Test if edge of byte reached
         inc      hl                ;Go to next byte
._notedge djnz     _iloop

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

         pop      bc                ;Restore data
         djnz     woloop
         ei
         ret

.wover_1 ld       c,(ix+2)
         inc      ix
         djnz     wiloop
         dec      ix

	; ---------
.actrow2
	ld	hl,0
	inc	hl
	inc	hl
	ld	(actrow2+1),hl
	
	ld	b,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,b

.actcol2
	ld	bc,0
	add	hl,bc
	; ---------

         pop      bc
         djnz     woloop
         ei
         ret

