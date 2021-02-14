;
;       Micro-Labs Grafyx Solution Hi-Rez graphics routines for TRS-80
;
;       Stefano Bodrato 2021
;

;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - nov 2010
;
;
; $Id: w_putsprite.asm $
;

        SECTION   smc_clib
        PUBLIC    putsprite
        PUBLIC    _putsprite

        INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)



.putsprite
._putsprite
        
		push ix
		
        ld      hl,4
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
		;xor		7		; alter opcode  "and/or/xor (hl)" -> "and/or/xor e"
         ld      (ortype+1),a    ; Self modifying code
        ld      (ortype2+1),a   ; Self modifying code

        inc     hl
        ld      a,(hl)
        ld      (ortype),a      ; Self modifying code
        ld      (ortype2),a     ; Self modifying code

        ;call    swapgfxbk
        ; @@@@@@@@@@@@
        ld      h,b
        ld      l,c
        ;ld      (curx),hl
        ;ld      (oldx),hl
        ;ld      (cury),de
        ;call    w_pixeladdress
		ld		a,l
        and     7               ;a = x mod 8
        xor     7
		ld		c,a
		
        srl     h               ;hl = x / 8
        rr      l
        srl     h
        rr      l
        srl     h
        rr      l
		
		ld		a,l
		out		(128),a
		ld		(x_sv),a
		ex       af,af		; keep x

		ld		a,e
		out		(129),a
		ld		h,a
		ld		(y_sv),a
		in		a,(130)
		ld		(curbyte),a
        ; @@@@@@@@@@@@
         ld       hl,offsets_table
         ;ld       c,a
         ld       b,0
         add      hl,bc
         ld       a,(hl)
         ld       (wsmc1+1),a
         ld       (wsmc2+1),a
         ld       (_smc1+1),a

        ;ld      h,d
        ;ld      l,e                 ; display location from pixeladdress
		ld		hl,curbyte

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
._iloop  sla      c                 ;Test leftmost pixel
         jp       nc,_noplot        ;See if a plot is needed
         ld       e,a
         ;call    swapgfxbk
         ld       a,e
.ortype
        nop     ; changed into nop / cpl
         nop    ; changed into and/or/xor (hl)
         ld       (hl),a
         ;call    swapgfxbk1
         ld       a,e
._noplot rrca
         jr       nc,_notedge       ;Test if edge of byte reached

        ;@@@@@@@@@@
        ;Go to next byte
        ;@@@@@@@@@@
		 ld       e,a
		 ld       a,(hl)
		 out      (130),a
 		 ex       af,af
		 inc      a
		 out      (128),a
		 ex       af,af
		 in       a,(130)
		 ld       (hl),a
		 ld       a,e
        ;@@@@@@@@@@

._notedge djnz     _iloop

        ;push   de
        ;@@@@@@@@@@
        ;Go to next line
        ;@@@@@@@@@@
		 ld       e,a
		 ld       a,(hl)
		 out      (130),a
		 ld       a,(x_sv)
		 out      (128),a
		 ex       af,af
		 ld       a,(y_sv)
		 inc      a
		 ld       (y_sv),a
		 out      (129),a
		 in       a,(130)
		 ld       (hl),a
		 ld       a,e
        ;@@@@@@@@@@
        ;pop     de
         pop      bc                ;Restore data
         djnz     _oloop
		 
         ;jp       __graphics_end
		 pop      ix
		 ret


.putspritew
         ld       d,a
         ld       b,(ix+1)        
.woloop  push     bc                ;Save # of rows
         ld       b,d               ;Load width
         ld       c,(ix+2)          ;Load one line of image
         inc      ix
.wsmc1    ld       a,1               ;Load pixel mask
.wiloop  sla      c                 ;Test leftmost pixel
         jp       nc,wnoplot         ;See if a plot is needed
         ld       e,a
         ;call    swapgfxbk
         ld       a,e
.ortype2
        nop     ; changed into nop / cpl
         nop    ; changed into and/or/xor (hl)
         ld       (hl),a
         ;call    swapgfxbk1
         ld       a,e
.wnoplot rrca
         jr       nc,wnotedge        ;Test if edge of byte reached

        ;@@@@@@@@@@
        ;Go to next byte
        ;@@@@@@@@@@
		 ld       e,a
		 ld       a,(hl)
		 out      (130),a
 		 ex       af,af
		 inc      a
		 out      (128),a
		 ex       af,af
		 in       a,(130)
		 ld       (hl),a
		 ld       a,e
        ;@@@@@@@@@@

.wnotedge
.wsmc2   cp       1
         jp       z,wover_1

         djnz     wiloop

.nextline

;        push   de
        ;@@@@@@@@@@
        ;Go to next line
        ;@@@@@@@@@@
		 ld       e,a
		 ld       a,(hl)
		 out      (130),a
		 ld       a,(x_sv)
		 out      (128),a
		 ex       af,af
		 ld       a,(y_sv)
		 inc      a
		 ld       (y_sv),a
		 out      (129),a
		 in       a,(130)
		 ld       (hl),a
		 ld       a,e
        ;@@@@@@@@@@
;        pop     de
         pop      bc                ;Restore data
         djnz     woloop

         ;jp       __graphics_end
		 pop      ix
		 ret
        

.wover_1 ld       c,(ix+2)
         inc      ix
         djnz     wiloop
         dec      ix
		 
		 jr nextline



	SECTION  bss_graphics
.x_sv
         defb   0
.y_sv
         defb   0
.curbyte
         defb   0


	SECTION	rodata_graphics
.offsets_table
         defb   1,2,4,8,16,32,64,128

