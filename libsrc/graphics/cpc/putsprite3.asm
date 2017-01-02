;
; Sprite Rendering Routine - Amstrad CPC version
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jul 2004
;
; Sept 2003 - Stefano: Fixed bug for sprites wider than 8.
;
; Much More Generic version
; Uses plotpixel, respixel and xorpixel
;
; This is a variant, even slower, of putsprite3.
; It is based on the BIOS calls, so it should be more flexible and compact.
; The XOR mode is totally untested.
;
;
; $Id: putsprite3.asm,v 1.7 2017-01-02 22:57:57 aralbrec Exp $
;


        SECTION   code_clib	
        PUBLIC    putsprite
        PUBLIC    _putsprite
        
        INCLUDE "cpcfirm.def"
        INCLUDE	"graphics/grafix.inc"


; __gfx_coords: h,l (vert-horz)
; sprite: (ix)

.putsprite
._putsprite
	push	ix		;save callers
        ld      hl,4   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
        push	de
        pop     ix

        inc     hl
        ld      e,(hl)
        inc     hl
        inc     hl
        ld      d,(hl)	; x and y __gfx_coords
        inc     hl
        inc     hl
        ld      a,(hl)  ; and/or/xor mode

	; 166 - and
	; 182 - or
	; 174 - xor

        cp      166	; and(hl) opcode
        jr      nz,noand
	
        push	de
        ld      a,bcolor
        call    firmware
        defw    gra_set_pen
        pop     de
        jr      modeset
.noand

        cp      174	; xor(hl) opcode
        jr      nz,modeset ; Probably we have an "OR"

        push	de
        ld      a,1	; XOR
        call    firmware
        defw    scr_access
        pop     de

.modeset
        ld      h,d
        ld      l,e

        ld      a,(ix+0)	; Width
        ld      b,(ix+1)	; Height
.oloopx	push	bc		;Save # of rows
        push	af

        ;ld	b,a		;Load width
        ld      b,0		; Better, start from zero !!

        ld      c,(ix+2)	;Load one line of image

.iloopx	sla     c		;Test leftmost pixel
        jr      nc,noplotx	;See if a plot is needed

        pop     af
        push	af

        push	hl
        push	bc
        push	de

        ld      a,h
        add     a,b
        ld      h,a

        ld      a,maxy
        sub     l
        ld      e,h
        ld      h,0
        ld      d,h
        ld      l,a

	;ld	h,0
	;ld	d,h
	;ld	e,a


        and     a		; double size (?)
        rl      l
        rl      h

        and     a
        rl      e
        rl      d

        call    firmware
        defw    gra_plot_absolute
        pop     de
        pop     bc
        pop     hl

.noplotx

        inc     b	; witdh counter
	
        pop     af
        push	af
	
        cp      b		; end of row ?
	
        jr      nz,noblkx
	
        inc     ix
        ld      c,(ix+2)	;Load next byte of image
	
        jr      noblockx
	
.noblkx
	
        ld      a,b	; next byte in row ?
        ;dec	a
        and     a
        jr      z,iloopx
        and     7
	
        jr      nz,iloopx
	
.blockx
        inc     ix
        ld      c,(ix+2)	;Load next byte of image
        jr      iloopx

.noblockx

        inc     l

        pop     af
        pop     bc		;Restore data
        djnz	oloopx
	
	
        ld      a,fcolor	;Restore fore color
        call    firmware
        defw    gra_set_pen

          
        ld      a,0	; FORCE mode (OR)
        call    firmware
        defw    scr_access
	pop	ix
        ret


