;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato
;
; TS2068 high resolution version
;
;
; $Id: w_putsprite.asm $
;

	SECTION   smc_clib
        PUBLIC    putsprite
        PUBLIC    _putsprite
        EXTERN     w_pixeladdress
		EXTERN     zx_saddrpdown

        EXTERN     swapgfxbk
        EXTERN    __graphics_end

        INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)

.putsprite
._putsprite
        push	ix		;save callers
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
        ld      (ortype+1),a    ; Self modifying code
        ld      (ortype2+1),a   ; Self modifying code

        inc     hl
        ld      a,(hl)
        ld      (ortype),a      ; Self modifying code
        ld      (ortype2),a     ; Self modifying code

        call    swapgfxbk
        ; @@@@@@@@@@@@
        ld      h,b
        ld      l,c
        call    w_pixeladdress
		ld	(saddr+1),de
		ld	(saddr1+1),de
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
._iloop  sla      c                 ;Test leftmost pixel
         jp       nc,_noplot        ;See if a plot is needed
         ld       e,a
.ortype
        nop     ; changed into nop / cpl
         nop    ; changed into and/or/xor (hl)
         ld       (hl),a
         ld       a,e
._noplot rrca

         jp       nc,_notedge       ;Test if edge of byte reached

        ;@@@@@@@@@@
        ;Go to next byte
        ;@@@@@@@@@@
         ex af,af
         ld     a,h
         xor    @00100000
         cp     h
         ld     h,a
         jp     nc,gonehi
         inc	hl
.gonehi
         ex af,af
        ;@@@@@@@@@@

._notedge djnz     _iloop

        ;push   de
        ;@@@@@@@@@@
        ;Go to next line
        ;@@@@@@@@@@
.saddr	ld hl,0
		call zx_saddrpdown
		ld	(saddr+1),hl
        ;@@@@@@@@@@
        ;pop     de
         pop      bc                ;Restore data
         djnz     _oloop
		 jp       __graphics_end


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
.ortype2
        nop     ; changed into nop / cpl
         nop    ; changed into and/or/xor (hl)
         ld       (hl),a
         ld       a,e
.wnoplot rrca
         jp       nc,wnotedge        ;Test if edge of byte reached

        ;@@@@@@@@@@
        ;Go to next byte
        ;@@@@@@@@@@
         ex af,af
         ld     a,h
         xor    @00100000
         cp     h
         ld     h,a
         jp     nc,wgonehi
         inc	hl
.wgonehi
         ex af,af
        ;@@@@@@@@@@

.wnotedge
.wsmc2   cp       1
         jp       z,wover_1

         djnz     wiloop

.close_line
        ;push   de
        ;@@@@@@@@@@
        ;Go to next line
        ;@@@@@@@@@@
.saddr1	ld hl,0
		call zx_saddrpdown
		ld	(saddr1+1),hl
        ;@@@@@@@@@@
        ;pop     de

         pop      bc                ;Restore data
         djnz     woloop
         jp       __graphics_end
        

.wover_1 ld       c,(ix+2)
         inc      ix
         djnz     wiloop
         dec      ix
		 jr close_line



	SECTION	rodata_clib
.offsets_table
         defb   1,2,4,8,16,32,64,128

