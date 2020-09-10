

    SECTION code_clib
    PUBLIC  w_pixeladdress

    INCLUDE "graphics/grafix.inc"



; Get absolute  pixel address in map of virtual (x,y) coordinate.
; in: (x,y) coordinate of pixel (hl,de)
;
; out: de       = address of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position

.w_pixeladdress
     ld     a,e
     cpl
     rrca
     ld     e,a
     ld     a,l  ;Save pixel
     srl    h    ;Divide by 8
     rr     l
     srl    h
     rr     l
     srl    h
     rr     l
     ld     h,a  ;Save pixel
     ld     a,l
     cpl
     ld     d,a
     ld     a,h
     cpl
     and    7
     ret 
