
	SECTION   code_clib
        PUBLIC    w_pixeladdress

        INCLUDE "graphics/grafix.inc"

        ;EXTERN   base_graphics
        EXTERN    _vdcDispMem

;
;       $Id: w_pixladdr.asm,v 1.5 2016-07-14 17:44:17 pauloscustodio Exp $
;

; ******************************************************************
;
; Get absolute  pixel address in map of virtual (x,y) coordinate.
;
; in:  hl,de    = (x,y) coordinate of pixel
;
; out: hl=de    = address of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ......hl/ixiy same
;  afbcde../.... different
;

.w_pixeladdress

        ld      b,h
        ld      c,l
                                ;calc (y * 80) + (x / 8) + bit map start
        ld      a,l             ;save y low byte for odd/even test

        srl     d               ;y = y/2
        rr      e
                                ;calc (y * 80) + (x / 8) + bit map start
        ld      l,e             ;hl = y
        ld      h,d

        add     hl,hl           ;hl = y * 16
        add     hl,hl
        add     hl,hl
        add     hl,hl
		ld		d,h
		ld		e,l
        add     hl,hl			;hl = y*64
        add     hl,hl

        add     hl,de           ;hl = (y * 64)+(y * 16)

        ld      e,c             ;de = x
        ld      d,b

        srl     d               ;de = x / 8
        rr      e
        srl     d
        rr      e
        srl     d
        rr      e

        add     hl,de           ;hl = (y * 80) + (x / 8)
        ld      de,(_vdcDispMem)
        add     hl,de           ;hl = (y * 80) + (x / 8) + bit map offset

        and     01h             ;test bit 0 to determine odd/even
        jr      nz,isodd        ;if y odd then
        ld      de,05370h       ; de = odd field offset of 21360 bytes
        add     hl,de           ; hl = hl+21360
isodd:
        ld      a,c             ;a = x low byte
        and     07h             ;a = x mod 8
        ;ld      d,0             ;de = x mod 8
        ;ld      e,a

        ld	d,h
        ld	e,l

	xor	7

        ret
        
