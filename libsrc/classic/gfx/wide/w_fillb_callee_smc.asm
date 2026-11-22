;
;    z88dk GFX library
;       2024 rework by Stefano Bodrato
;
; Usage: fillb(int tlx, int tly, int tlx2, int tly2)
;

    INCLUDE "classic/gfx/grafix.inc"

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    SECTION smc_clib

    PUBLIC  fillb_callee
    PUBLIC  _fillb_callee

    PUBLIC  asm_fillb

    EXTERN  w_pixeladdress
    EXTERN  leftbitmask, rightbitmask
;;    EXTERN  __gfx_fatpix

    EXTERN  l_cmp
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN __generic_w_curx
    EXTERN __generic_w_cury
    EXTERN __generic_w_incx


fillb_callee:
_fillb_callee:

    pop     af  ; ret addr
    pop     de  ; tly2
    pop     hl  ; tlx2
    exx                                 ; w_plotpixel and __gfx_vram_page_in must not use the alternate registers, no problem with w_line_r
    pop     de  ; tly1
    pop     hl  ; tlx1
    push    af                          ; ret addr
    exx

asm_fillb:

    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF


;    push    hl           ; width
    ld      (__fillb_height+1),de
    
    exx  ; hl=x
         ; de=y

;;;   TODO_ check for Y + Ysz overflow

    push    de
    ld      de, _GFX_MAXX+1
    call    l_cmp
    pop     de
    jp      c, __graphics_end          ; Return if X overflows
    
    push    hl
    ld      hl, _GFX_MAXY
    call    l_cmp
    pop     hl
    jp      nc, __graphics_end          ; Return if Y overflows

    push    de                          ; y pos
    push    hl                          ; x pos
	ld (x1pos+1),hl
    ld (clear_nextrow+1),hl
    ld (__generic_w_curx),hl
    ld (__generic_w_cury),de
    call    w_pixeladdress                ; bitpos0 = pixeladdress(x,y)
    call    leftbitmask                 ; LeftBitMask(bitpos0)
    cpl
    ld      (bitmaskl1+1), a            ; SMC
    ld      (bitmaskl2+1), a            ; SMC
    
    exx                                 ; hl,de = x and y sz
    pop     bc                          ; x pos
    dec     bc     ;;  Something is wrong, fix 1px horizontal gap
    add     hl,bc                       ; x2 pos

    ld      de, _GFX_MAXX+1
    call    l_cmp
    jp      c, __graphics_end          ; Return if X overflows
    
    pop     de  ; y pos (let's destroy y size)
	push    hl  ; x2 pos

    call    w_pixeladdress                ; bitpos1 = pixeladdress(x+width-1,y)
    call    rightbitmask                ; RightBitMask(bitpos1)
    cpl
    ld      (bitmaskr1+1), a
    ld      (bitmaskr2+1), a            ; bitmask1 = LeftBitMask(bitpos0)

    pop     hl
	srl     h
	rr      l
	srl     h
	rr      l
	srl     h
	rr      l
	ld      a,l
x1pos:
    ld      hl,0
	srl     h
	rr      l
	srl     h
	rr      l
	srl     h
	rr      l
	sub     l

    ld      (rowbytes1+1), a
    ld      (rowbytes2+1), a             ; rowbytes = (adr1-adr0) div 8, no. of bytes in row

       ; 0 means that area is within same address
       ; FOR h = 1 TO height

clear_main:
    ld hl,(__generic_w_curx)
    ld de,(__generic_w_cury)
    call    w_pixeladdress                ; bitpos0 = pixeladdress(x,y)

;-------------------
rowbytes1:
    ld      a,0
    and     a                           ; if rowbytes = 0
    jr      nz, clear_row               ; area is within one byte...

;-------------------
; Single byte 
    ld    a,(de)
bitmaskl1:
    or      0                           ; preserve bits of leftmost side of byte
    ld      b, a
    ld    a,(de)
bitmaskr1:
    or      0                           ; preserve bits of rightmost side of byte
    or      b                           ; merge preserved bits of left side
    ld    (de),a                     ; (offset) = byte
    jr      clear_nextrow               ; else

; Multi-byte
;-------------------
clear_row:                              ; clear area is defined as rows of bytes
    ld    a,(de)
bitmaskl2:
    or      0                           ; preserve only leftmost bits (outside of area)
    ld    (de),a                     ; (offset) = (offset) AND bitmask0

    ;inc     de                          ; offset += 1 (8 bits)
    call __generic_w_incx

rowbytes2:
    ld      b, 0                         ; r = rowbytes
    dec     b                            ; --r
    jr      z, row_cleared              ; if    ( r )
clear_row_loop:                         ; do
    ld    a,255
    ld    (de),a                     ; (offset) = 0

;    inc     de                          ; offset += 1 (8 bits)
    call __generic_w_incx

    djnz    clear_row_loop              ; while ( r-- != 0 )
row_cleared:
    ld    a,(de)                     ; byte = (adr1)
bitmaskr2:
    or      0
    ld    (de),a                     ; preserve only rightmost side of byte (outside area)

;-------------------
clear_nextrow:
    ld hl,0
    ld (__generic_w_curx),hl
    ld de,(__generic_w_cury)
    inc de
    ld (__generic_w_cury),de

       ; END FOR    h
__fillb_height:
    ld      bc,0
    dec     bc
    ld      (__fillb_height+1),bc
    ld      a,b
    or      c
    jp      z, __graphics_end
    jr      clear_main

ENDIF
