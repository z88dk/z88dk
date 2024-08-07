
    SECTION smc_clib

    PUBLIC  cleararea

    EXTERN  __gal_mode
    EXTERN  __generic_clrarea
    EXTERN  pixeladdress_MODE1
    EXTERN  leftbitmask, rightbitmask

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
    ld      a, (__gal_mode)
    cp      1
    jp      z, cleararea_MODE1
    and     a
    ret     nz
    jp      __generic_clrarea


cleararea_MODE1:
    ld      (coord+1), hl               ; SMC: remember y,x
    inc     b
    push    bc                          ; remember height
    push    bc
    push    hl
    call    pixeladdress_MODE1                ; bitpos0 = pixeladdress(x,y)
    ex      de,hl
    pop     hl
    call    rightbitmask                 ; LeftBitMask(bitpos0)
    cpl    ;;  we need "fill" in place of "clear"
    ld      (bitmaskl1+1), a            ; SMC
    ld      (bitmaskl2+1), a            ; SMC
    pop     bc
    ld      a, h
    add     b
    dec     a
    ;dec     a
    ld      h, a
    push    de
    call    pixeladdress_MODE1                ; bitpos1 = pixeladdress(x+width-1,y)
    ex      de,hl
    call    rightbitmask                ; RightBitMask(bitpos1)
    ld      (bitmaskr1+1), a
    ld      (bitmaskr2+1), a            ; bitmask1 = LeftBitMask(bitpos0)
    pop     hl
    push    hl                          ; adr0
    ex      de, hl
    cp      a
    sbc     hl, de                      ; (adr1-adr0)/8
    ld      a, l
    ld      (rowbytes1+1), a
    ld      (rowbytes2+1), a            ; rowbytes = (adr1-adr0) div 8, no. of bytes in row
       ; 0 means that area is within same address
       ; FOR h = 1 TO height
    pop     hl                          ; adr0
clear_height:
    xor     a
rowbytes1:
    cp      0                           ; if rowbytes = 0
    jr      nz, clear_row               ; area is within one byte...
    ld      a, (hl)
bitmaskl1:
    or      0                           ; preserve bits of leftmost side of byte
    ld      b, a
    ld      a, (hl)
bitmaskr1:
    or      0                           ; preserve bits of rightmost side of byte
    or      b                           ; merge preserved bits of left side
    ld      (hl), a                     ; (offset) = byte
    jr      clear_nextrow               ; else
clear_row:                              ; clear area is defined as rows of bytes
    ld      a, (hl)
bitmaskl2:
    or      0                           ; preserve only leftmost bits (outside of area)
    ld      (hl), a                     ; (offset) = (offset) AND bitmask0
    inc     hl                          ; offset += 1 (8 bits)
rowbytes2:
    ld      b, 0                        ; r = rowbytes
    dec     b                           ; --r
    jr      z, row_cleared              ; if    ( r )
clear_row_loop:                         ; do
    ld      (hl), 255                     ; (offset) = 0
    inc     hl                          ; offset += 1 (8 bits)
    djnz    clear_row_loop              ; while ( r-- != 0 )
row_cleared:
    ld      a, (hl)                     ; byte = (adr1)
bitmaskr2:
    or      0
    ld      (hl), a                     ; preserve only rightmost side of byte (outside area)

clear_nextrow:
coord:
    ld      hl, 0                       ; SMC -> y,x
    inc     l
    ld      (coord+1), hl               ; SMC -> y,x
    call    pixeladdress_MODE1
    ;ex      de, hl                      ; put adr0 in hl for next row

       ; END FOR    h
height:
    pop     bc
    dec     c                           ; height
    push    bc
    jr      nz, clear_height
    pop     bc

end_cleararea:
    ret
