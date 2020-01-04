;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2009
;
; MSX version
;
;
; $Id: putsprite.asm,v 1.5 2016-07-02 09:01:35 dom Exp $
;

	SECTION	smc_clib
	PUBLIC    putsprite
	PUBLIC    _putsprite
	EXTERN		pixeladdress
	EXTERN	pixelbyte
	EXTERN	pix_return
	EXTERN	gfxbyte_get
	EXTERN     swapgfxbk
	EXTERN	swapgfxbk1

	INCLUDE	"graphics/grafix.inc"


; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


.putsprite
._putsprite
	push	ix		;save cllers
        ld      hl,4   
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
        ld	(ortype+1),a	; Self modifying code
        ld	(ortype2+1),a	; Self modifying code

        inc     hl
        ld      a,(hl)
        ld	(ortype),a	; Self modifying code
        ld	(ortype2),a	; Self modifying code


	ld	h,d
	ld	l,e

	ld	(actcoord),hl	; save current coordinates

	call    swapgfxbk
	call	pixeladdress

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
	jr	nc,putspritew

         ld       d,(ix+0)
         ld       b,(ix+1)
._oloop  push     bc                ;Save # of rows
         ld       b,d               ;Load width
         ld       c,(ix+2)          ;Load one line of image
         inc      ix
._smc1   ld       a,1               ;Load pixel mask
._iloop
	 push     hl			;*
	 ld       hl,pixelbyte		;*
	 sla      c                 ;Test leftmost pixel
         jr       nc,_noplot        ;See if a plot is needed
         ld       e,a
.ortype
	nop	; changed into nop / cpl
         nop	; changed into and/or/xor (hl)
	 ld       (hl),a
         ld       a,e
._noplot rrca
         pop      hl			;*
         call     c,_edge        ;If edge of byte reached, go to next byte
         djnz     _iloop

	; ---------
         call     _row
	; ---------

         pop      bc                ;Restore data
         djnz     _oloop
	pop	ix		;restore callers
	 jp       swapgfxbk1


.putspritew
         ld       d,(ix+0)
         ld       b,(ix+1)        
.woloop  push     bc                ;Save # of rows
         ld       b,d               ;Load width
         ld       c,(ix+2)          ;Load one line of image
         inc      ix
.wsmc1    ld       a,1               ;Load pixel mask
.wiloop
	 push     hl			;*
	 ld       hl,pixelbyte		;*
         sla      c                 ;Test leftmost pixel
         jr       nc,wnoplot         ;See if a plot is needed
         ld       e,a

.ortype2
	nop	; changed into nop / cpl
         nop	; changed into and/or/xor (hl)
         ld       (hl),a
         ld       a,e
.wnoplot rrca
         pop      hl			;*
         call     c,_edge        ;If edge of byte reached, go to next byte
.wsmc2   cp       1
         jr       z,wover_1
         djnz     wiloop

	; ---------
         call     _row
	; ---------

         pop      bc                ;Restore data
         djnz     woloop
	pop	ix		;restore callers
	 jp       swapgfxbk1
	

.wover_1 ld       c,(ix+2)
         inc      ix
         djnz     wiloop
         dec      ix

	; ---------
         call     _row
	; ---------

         pop      bc
         djnz     woloop
	 jp       swapgfxbk1


; Edge of byte reached, save its content,
; increment video ptr, and get new byte.
._edge
         push     af
;**************
		ld	a,(pixelbyte)
		ex	de,hl
		call pix_return		; ld (de),a  ..in VRAM
		ex	de,hl
;**************
         ;ld       a,8
         ;add      l
         ;ld       l,a
         
         ;jr       nc,nozh
         ;inc      h
;.nozh
         inc      hl                ;Go to next byte
;**************
		push hl
		push de
		call	gfxbyte_get		; ld (pixelbyte),(hl)  ..in VRAM
		pop de
		pop hl
		;ld	a,(pixelbyte)
		;ex	de,hl
		;call pix_return
		;ex	de,hl
;**************
         pop      af
         ret

._row
	push	af
;**************
		ld	a,(pixelbyte)
		ex	de,hl
		call pix_return
		ex	de,hl
;**************
	push	de
	ld	hl,(actcoord)
	inc	l
	ld	(actcoord),hl
	call	pixeladdress
	ld	h,d
	ld	l,e
	pop	de
	pop	af
	ret
        
	SECTION	rodata_clib
.offsets_table
         defb	1,2,4,8,16,32,64,128
	SECTION bss_clib
.actcoord
	 defw	0
