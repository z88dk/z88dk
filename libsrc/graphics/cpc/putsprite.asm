;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Apr. 2008
;
; Amstrad CPC version
;
;
; $Id: putsprite.asm,v 1.6 2016-07-02 09:01:35 dom Exp $
;

        SECTION   code_clib
        PUBLIC    putsprite
        PUBLIC    _putsprite
        EXTERN     pixeladdress

        INCLUDE "cpcfirm.def"
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
        ld      a,maxy
        sub	(hl)	; y position
        ld      c,a
        ld	b,0
        inc     hl
        inc     hl
        ld      e,(hl)  ; x position
        inc     hl
        ld	d,(hl)

        inc     hl
        ld      a,(hl)  ; and/or/xor mode
        ld      (ortype+1),a    ; Self modifying code
        ld      (ortype2+1),a   ; Self modifying code

        inc     hl
        ld      a,(hl)
        ld      (ortype),a      ; Self modifying code
        ld      (ortype2),a     ; Self modifying code

        ld	h,b	; x position
        ld	l,c

        call    firmware
        defw    scr_dot_position

        ld      (s_line_addr),hl

        ld      a,15
        and     c

        ld      (_smc1+1),a
        ld      (wsmc1+1),a
        ld      (wsmc2+1),a

        ld      a,(ix+0)
        cp      9
        jr      nc,putspritew


;-------------------
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
         ld       a,8               ;Re-set the edge of byte
         inc      hl                ;Go to next byte
._notedge djnz     _iloop

        ld      hl,(s_line_addr)
        call    firmware
        defw    scr_next_line
        ld      (s_line_addr),hl

         pop      bc                ;Restore data
         djnz     _oloop
	pop	ix
         ret

;-------------------
.putspritew
         ld       d,a
         ld       b,(ix+1)        
.woloop  push     bc                ;Save # of rows
         ld       b,d               ;Load width
         ld       c,(ix+2)          ;Load one line of image
         inc      ix

.wsmc1   ld       a,1               ;Load pixel mask & reset Z flag
	 ld	  e,2

.wiloop  sla      c                 ;Test leftmost pixel
         jp       nc,wnoplot        ;See if a plot is needed

         push     af
.ortype2
        nop     ; changed into nop / cpl
         nop    ; changed into and/or/xor (hl)
         
         ld       (hl),a
         pop      af
         
.wnoplot rrca
         jp       nc,wnotedge       ;Test if edge of byte reached
         inc      hl                ;Go to next byte
         ld	  a,8

.wnotedge
.wsmc2   cp       1
         jp       nz,wnotedge2
         
         dec	  e
         jr	  z,wover_1

.wnotedge2
         djnz     wiloop

        ld      hl,(s_line_addr)
        call    firmware
        defw    scr_next_line
        ld      (s_line_addr),hl

         pop      bc                ;Restore data
         djnz     woloop
         ret
        

.wover_1
	ld e,2
         ld       c,(ix+2)
         inc      ix
         djnz     wiloop
         dec      ix

        ld      hl,(s_line_addr)
        call    firmware
        defw    scr_next_line
        ld      (s_line_addr),hl

         pop      bc
         djnz     woloop
	pop	ix
         ret

	SECTION	bss_clib
.s_line_addr
         defw   0
