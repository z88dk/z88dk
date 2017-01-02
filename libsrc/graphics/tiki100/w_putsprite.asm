;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - nov 2010
;
; TIKI-100 high resolution version
;
;
; $Id: w_putsprite.asm,v 1.5 2017-01-02 22:57:59 aralbrec Exp $
;

		SECTION code_clib
        PUBLIC    putsprite
        PUBLIC    _putsprite
        EXTERN    w_pixeladdress

        EXTERN    swapgfxbk
        EXTERN    swapgfxbk1

        INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


.offsets_table
         defb   1,2,4,8,16,32,64,128


.putsprite
._putsprite
		
        ld      hl,2   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ; sprite address
        push    de
        pop     ix

        inc     hl
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)  ; x and y __gfx_coords

        inc     hl
        ld      a,(hl)  ; and/or/xor mode
        ld      (ortype+1),a    ; Self modifying code
        ld      (ortype2+1),a   ; Self modifying code

        inc     hl
        ld      a,(hl)
        ld      (ortype),a      ; Self modifying code
        ld      (ortype2),a     ; Self modifying code

        ; @@@@@@@@@@@@
        ld      h,b
        ld      l,c
        call    w_pixeladdress
	ld	(rowadr1+1),hl	; store current row
	ld	(rowadr2+1),hl
	ld	(rowadr3+1),hl
        ; ------
        ;ld		a,(hl)
        ; @@@@@@@@@@@@
         ld       c,a
         ld       hl,offsets_table
         ld       c,a
         ld       b,0
         add      hl,bc
         ld       a,(hl)
         ld       (wsmc1+1),a
         ld       (wsmc2+1),a
         ld       (_smc1+1),a

        ld      h,d
        ld      l,e                 ; display location from pixeladdress

        ld      a,(ix+0)
        cp      9
        jp      nc,putspritew

         ld       d,a
         ld       b,(ix+1)
._oloop  push     bc                ;Save # of rows
         ld       b,d               ;Load width
         ld       c,(ix+2)          ;Load one line of image
         inc      ix
._smc1   ld       a,1               ;Load pixel mask
         call    swapgfxbk
._iloop  sla      c                 ;Test leftmost pixel
         jp       nc,_noplot        ;See if a plot is needed
         ld       e,a
.ortype
        nop     ; changed into nop / cpl
         nop    ; changed into and/or/xor (hl)
         ld       (hl),a
         ld       a,e
._noplot rlca

         jr       nc,_notedge       ;Test if edge of byte reached

        ;@@@@@@@@@@
        ;Go to next byte
        ;@@@@@@@@@@
		inc hl
        ;@@@@@@@@@@

._notedge djnz     _iloop
         call    swapgfxbk1

        ;@@@@@@@@@@
        ;Go to next line
        ;@@@@@@@@@@
.rowadr1
		ld	hl,0	; current address
		ex	af,af
		ld	a,128
		add	l
		ld l,a
		jr	nc,row1
		inc h
.row1
		ld	(rowadr1+1),hl
        ;@@@@@@@@@@
         pop      bc                ;Restore data
         djnz     _oloop
         ret


.putspritew
         ld       d,a
         ld       b,(ix+1)        
.woloop  push     bc                ;Save # of rows
         ld       b,d               ;Load width
         ld       c,(ix+2)          ;Load one line of image
         inc      ix
.wsmc1    ld       a,1               ;Load pixel mask
         call    swapgfxbk
.wiloop  sla      c                 ;Test leftmost pixel
         jp       nc,wnoplot         ;See if a plot is needed
         ld       e,a
.ortype2
        nop     ; changed into nop / cpl
         nop    ; changed into and/or/xor (hl)
         ld       (hl),a
         ld       a,e
.wnoplot rlca
         jr       nc,wnotedge        ;Test if edge of byte reached

        ;@@@@@@@@@@
        ;Go to next byte
        ;@@@@@@@@@@
		inc hl
        ;@@@@@@@@@@

.wnotedge
.wsmc2   cp       1
         jp       z,wover_1

         djnz     wiloop
         call    swapgfxbk1

        ;@@@@@@@@@@
        ;Go to next line
        ;@@@@@@@@@@
.rowadr2
		ld	hl,0	; current address
		ex	af,af
		ld	a,128
		add	l
		ld l,a
		jr	nc,row2
		inc h
.row2
		ld	(rowadr2+1),hl
        ;@@@@@@@@@@

         pop      bc                ;Restore data
         djnz     woloop
		 ret
        

.wover_1
         call    swapgfxbk1
         ld       c,(ix+2)
         call    swapgfxbk
         inc      ix
         djnz     wiloop
         call    swapgfxbk1
         dec      ix

        ;@@@@@@@@@@
        ;Go to next line
        ;@@@@@@@@@@
.rowadr3
		ld	hl,0	; current address
		ex	af,af
		ld	a,128
		add	l
		ld l,a
		jr	nc,row3
		inc h
.row3
		ld	(rowadr3+1),hl
        ;@@@@@@@@@@

         pop      bc
         djnz     woloop
         ret

