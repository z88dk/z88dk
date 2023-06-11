;
;       Graphics routines for the Robotron Z1013
;
;       KRT 256x256

    SECTION code_clib
    PUBLIC  pixeladdress
    EXTERN  KRT_PORT
    EXTERN  KRT_ADDRESS

    INCLUDE "graphics/grafix.inc"

;
; ******************************************************************
; Get absolute  pixel address in map of virtual (x,y) coordinate.
; in: (x,y) coordinate of pixel (h,l)
; 
; out: de = hl  = address of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ..bc..../ixiy same
;  af..dehl/.... different

.pixeladdress
    ex      de,hl
    ld      a,e
    and     7
    out     (KRT_PORT), a
    ld      l,e         ;Already *8
    ld      h,0
    add     hl,hl       ;*16
    add     hl,hl       ;*32
    ld      a,l
    and     @11100000
    ld      e,d
    srl     e
    srl     e
    srl     e
    add     e
    ld      l,a
    ld	    a,+(KRT_ADDRESS / 256)
    add     h
    ld      h,a
    ld      a,d
    and     7
    xor     7
    ld      d,h
    ld      e,l
    ret
