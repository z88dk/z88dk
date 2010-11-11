; libsrc/graphics/ts2068hr/w_pixladdr.asm
; posted by rdk77, 11/11/2010

        XLIB    w_pixeladdress
        LIB     zx_rowtab

        INCLUDE "graphics/grafix.inc"
;
;       $Id: w_pixladdr.asm,v 1.1 2010-11-11 18:01:40 stefano Exp $
;
; ******************************************************************
; Get absolute  pixel address in map of virtual (x,y) coordinate.
; in: (x,y) coordinate of pixel (hl,de)
; 
; out: de       = address       of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ..bc..../ixiy same
;  af..dehl/.... different

.w_pixeladdress
                ex      de,hl
                add     hl,hl
                push    de
                ld      de,zx_rowtab
                add     hl,de
                ld      e,(hl)
                inc     hl
                ld      d,(hl)
                pop     hl
                bit     3,l
                jr      z,first
                set     5,d
.first
                ld      a,l
                srl     l
                srl     l
                srl     l
                srl     l
                bit     0,h
                jr      z,nset
                set     4,l
.nset
                ld      h,0
                add     hl,de
                ex      de,hl
                and     @00000111
                xor     @00000111
                ret
