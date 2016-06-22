
	SECTION	  code_clib
        PUBLIC    w_pixeladdress

        INCLUDE "graphics/grafix.inc"

        EXTERN   base_graphics

;
;
;       Stefano - Sept 2011
;
;	$Id: w_pixladdr.asm,v 1.4 2016-06-22 22:40:19 dom Exp $
;
;
; ******************************************************************
; Get absolute  pixel address in map of virtual (x,y) coordinate.
; in: (x,y) coordinate of pixel (hl,de)
; 
; out: de       = address of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ..bc..../ixiy same
;  af..dehl/.... different

.w_pixeladdress

        ld      b,h
        ld      c,l
                                ;calc (y * 40) + (x / 8) + bit map start
        ld      l,e             ;hl = y
        ld      h,d

        add     hl,hl           ;hl = y * 8
        add     hl,hl
        add     hl,hl
        ld		d,h
        ld		e,l
        add     hl,hl           ;hl = y * 32
        add     hl,hl
        
        add     hl,de           ;hl = (y * 32)+(y * 8)

        ld      e,c             ;de = x
        ld      d,b

        srl     d               ;de = x / 8
        rr      e
        srl     d
        rr      e
        srl     d
        rr      e

        add     hl,de           ;hl = (y * 40) + (x / 8)
        ld      de,(base_graphics)
        add     hl,de           ;hl = (y * 40) + (x / 8) + bit map offset

        ld      a,c             ;a = x low byte
        and     07h             ;a = x mod 8
        
        ld	d,h
        ld	e,l
        
        xor     7

        ret
