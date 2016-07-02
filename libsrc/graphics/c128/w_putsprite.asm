;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; c128 high resolution version
;
;
; $Id: w_putsprite.asm,v 1.5 2016-07-02 09:01:35 dom Exp $
;

	SECTION   smc_clib
        PUBLIC    putsprite
        PUBLIC   _putsprite
        EXTERN     w_pixeladdress
        ;EXTERN    vdcset
        ;EXTERN    vdcget
        ;EXTERN    swapgfxbk
        ;EXTERN  swapgfxbk1

        INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


.putsprite
._putsprite
	push	ix        	;save callers
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

        ;call    swapgfxbk
        ; @@@@@@@@@@@@
        ld      h,b
        ld      l,c
        call    w_pixeladdress
        ex      af,af

	ld	d,18
        ld      bc,0d600h
        out     (c),d
loopa1:
        in      a,(c)
        rla
        jp      nc,loopa1
        inc	c
        out     (c),h

        dec	c
        inc	d
        out     (c),d
loopa2:
        in      a,(c)
        rla
        jp      nc,loopa2
        inc	c
        out     (c),l

        dec	c
        ld	a,31
        out     (c),a
loopa3:
        in      a,(c)
        rla
        jp      nc,loopa3
        inc	c
        in      a,(c)

        exx
        ld      hl,actbyte          ; don't point directly to the display address
        ld      (hl),a
        exx
        ld      (lineaddr),hl
        ld	d,h
        ld	e,l
        ex      af,af
        ; @@@@@@@@@@@@

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

         exx                        ; now hl point to "actbyte"
.ortype
        nop     ; changed into nop / cpl
         nop    ; changed into and/or/xor (hl)
         ld       (hl),a
         exx                        ; make HL point back to display address
         ld       a,e
._noplot rrca

         call      c,edge_reached

._notedge djnz     _iloop

         call     next_line

         pop      bc                ;Restore data
         djnz     _oloop
	pop	ix		;restore callers
         ret
         ;jp       swapgfxbk1


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

         exx                        ; now hl point to "actbyte"
.ortype2
        nop     ; changed into nop / cpl
         nop    ; changed into and/or/xor (hl)
         ld       (hl),a
         exx                        ; make HL point back to display address
         ld       a,e
.wnoplot rrca

         call      c,edge_reached

.wnotedge
.wsmc2   cp       1
         jp       z,wover_1

         djnz     wiloop

         call     next_line

         pop      bc                ;Restore data
         djnz     woloop
	 pop	ix		;restore callers
         ret
         ;jp       swapgfxbk1
        

.wover_1 ld       c,(ix+2)
         inc      ix
         djnz     wiloop
         dec      ix

         call     next_line

         pop      bc
         djnz     woloop
	 pop	ix		;restore callers
         ret
         ;jp       swapgfxbk1


;_____________________________________________________

.edge_reached
        push   de
        push   bc
        ex     af,af

	ld	d,18
        ld      bc,0d600h
        out     (c),d
loop1:
        in      a,(c)
        rla
        jp      nc,loop1
        inc	c
        out     (c),h

        dec	c
        inc	d
        out     (c),d
loop2:
        in      a,(c)
        rla
        jp      nc,loop2
        inc	c
        out     (c),l

        dec	c
        ld	a,31
        out     (c),a
loop3:
        in      a,(c)
        rla
        jp      nc,loop3
        inc	c
        ld      a,(actbyte)
	out     (c),a

        ;@@@@@@@@@@
         inc     hl              ;Go to next byte
        ;@@@@@@@@@@

        dec	c
        dec	d
        out     (c),d
loop4:
        in      a,(c)
        rla
        jp      nc,loop4
        inc	c
        out     (c),h

        dec	c
        inc	d
        out     (c),d
loop5:
        in      a,(c)
        rla
        jp      nc,loop5
        inc	c
        out     (c),l

        dec	c
        ld	a,31
        out     (c),a
loop6:
        in      a,(c)
        rla
        jp      nc,loop6
        inc	c
        in      a,(c)
        ld      (actbyte),a
	
	ex	af,af
        pop     bc
        pop     de
        ret
;_____________________________________________________

.next_line
        push   de
        push   bc
        ex     af,af

	ld	d,18
        ld      bc,0d600h
        out     (c),d
loop1a:
        in      a,(c)
        rla
        jp      nc,loop1a
        inc	c
        out     (c),h

        dec	c
        inc	d
        out     (c),d
loop2a:
        in      a,(c)
        rla
        jp      nc,loop2a
        inc	c
        out     (c),l

        dec	c
        ld	a,31
        out     (c),a
loop3a:
        in      a,(c)
        rla
        jp      nc,loop3a
        inc	c
        ld      a,(actbyte)
	out     (c),a
	
        ;@@@@@@@@@@
         ld      hl,(lineaddr)
         ld      de,80
         add     hl,de
         ld      (lineaddr),hl
        ;@@@@@@@@@@

	ld	d,18
        dec	c
        out     (c),d
loop4a:
        in      a,(c)
        rla
        jp      nc,loop4a
        inc	c
        out     (c),h

        dec	c
        inc	d
        out     (c),d
loop5a:
        in      a,(c)
        rla
        jp      nc,loop5a
        inc	c
        out     (c),l

        dec	c
        ld	a,31
        out     (c),a
loop6a:
        in      a,(c)
        rla
        jp      nc,loop6a
        inc	c
        in      a,(c)
        ld      (actbyte),a

        ex     af,af

        pop     bc
        pop     de
        ret

	SECTION	rodata_clib
.offsets_table
         defb   1,2,4,8,16,32,64,128
	SECTION	bss_clib
.lineaddr
         defw   0
.actbyte
         defb   0
