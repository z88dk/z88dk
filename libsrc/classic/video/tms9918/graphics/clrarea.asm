
    SECTION smc_video_vdp

    PUBLIC  cleararea
    PUBLIC  _cleararea

    EXTERN  pixeladdress
    EXTERN  leftbitmask, rightbitmask

    EXTERN  __tms9918_pixeladdress
    EXTERN  __tms9918_pixelbyte
    EXTERN  __tms9918_fetch
    EXTERN  __tms9918_store
    EXTERN  __tms9918_attribute
    EXTERN  __tms9918_screen_mode

    EXTERN  __generic_clrarea

    INCLUDE "classic/gfx/grafix.inc"
    INCLUDE "classic/video/tms9918/vdp.inc"

;
;    $Id: clrarea.asm $
;

; ***********************************************************************
;
; Clear specified graphics area in map.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; Generic SMC version by Stefano Bodrato.
;
;
;
; IN:    HL    = (x,y)
;    BC    = (width,heigth)
;
; Registers changed after return:
;   ......../IXIY same
;   AFBCDEHL/.... different
;

cleararea:
_cleararea:
    ld      a, (__tms9918_screen_mode)
    cp      2
IFDEF   V9938
    jr      z, dorender
    cp      4
ENDIF
    jp      nz, __generic_clrarea
dorender:
    ld      (coord+1), hl               ; SMC: remember y,x
    inc     b
    push    bc                          ; remember height
    push    bc
    push    hl

; --- Different way to compute the horizontal byte boundary ---
    ld      a,h
    and     7
    dec     a
    ccf               ; CY reset if we're at a byte boundary
    ld      a,0
    adc     b         ; otherwise add 1/8 more and include one extra byte
    rra
    srl a
    srl a
;	dec a
    ld      (rowbytes1+1), a
    ld      (rowbytes2+1), a            ; 0 means that area is within same address
; --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    call    __tms9918_pixeladdress                ; bitpos0 = pixeladdress(x,y)
    pop     hl
    call    leftbitmask                 ; LeftBitMask(bitpos0)
    ld      (bitmaskl1+1), a            ; SMC
    ld      (bitmaskl2+1), a            ; SMC
    pop     bc
    ld      a, h
    add     b
    dec     a
    dec     a
    ld      h, a
    ;;; ld      (row_cleared+1),hl
    push    de
    call    __tms9918_pixeladdress                ; bitpos1 = pixeladdress(x+width-1,y)
    call    rightbitmask                ; RightBitMask(bitpos1)
    ld      (bitmaskr1+1), a
    ld      (bitmaskr2+1), a            ; bitmask1 = LeftBitMask(bitpos0)
    pop     hl


;    push    hl                          ; adr0
;    ex      de, hl
;    cp      a
;    sbc     hl, de                      ; (adr1-adr0)/8
;    srl     h
;    rr      l
;    srl     h
;    rr      l
;    srl     h
;    rr      l
;    ld      a, l                        ;
;    ld      (rowbytes1+1), a
;    ld      (rowbytes2+1), a            ; rowbytes = (adr1-adr0) div 8, no. of bytes in row
;       ; 0 means that area is within same address
;       ; FOR h = 1 TO height
;    pop     hl                          ; adr0



; FOR h = 1 TO height

clear_height:
    xor     a
	ld      de,8
rowbytes1:
    cp      0                           ; if rowbytes = 0
    jr      nz, clear_row               ; area is within one byte...
    ld      a, (__tms9918_pixelbyte)

bitmaskl1:
    and     0                           ; preserve bits of leftmost side of byte
    ld      b, a
    ld      a, (__tms9918_pixelbyte)

bitmaskr1:
    and     0                           ; preserve bits of rightmost side of byte
    or      b                           ; merge preserved bits of left side
;    ld      (hl), a                     ; (offset) = byte
    call    __tms9918_store
    jp      clear_nextrow               ; else

clear_row:                              ; clear area is defined as rows of bytes
;    ld      a, (hl)
    ld      hl,(coord+1)                ; SMC -> y,x
    call    __tms9918_pixeladdress
    ex      de, hl                      ; put adr0 in hl for next row
    ld      a, (__tms9918_pixelbyte)

bitmaskl2:
    and     0                           ; preserve only leftmost bits (outside of area)
;    ld      (hl), a                     ; (offset) = byte
    call    __tms9918_store

;    inc     hl                          ; offset += 1 (8 bits)
    ld      a, 8
    add     l
    ld      l, a

rowbytes2:
    ld      b, 0                        ; r = rowbytes
    dec     b                           ; --r
    jr      z, row_cleared              ; if    ( r )

clear_row_loop:                         ; do
    ;ld      (hl), 0                     ; (offset) = 0
    xor     a
    call    __tms9918_store

;    inc     hl                          ; offset += 1 (8 bits)
    ld      a, 8
    add     l
    ld      l, a

    djnz    clear_row_loop              ; while ( r-- != 0 )

row_cleared:

;  fetch_byte
;**************

    call    __tms9918_fetch

;**************

bitmaskr2:
    and     0
;    ld      (hl), a                     ; (offset) = byte
    call    __tms9918_store

clear_nextrow:
coord:
    ld      hl, 0                       ; SMC -> y,x
    inc     l
    ld      (coord+1), hl               ; SMC -> y,x
    call    __tms9918_pixeladdress
    ex      de, hl                      ; put adr0 in hl for next row

       ; END FOR    h
height:
    pop     bc
    dec     c                           ; height
    push    bc
    jp      nz, clear_height
    pop     bc

    ret



