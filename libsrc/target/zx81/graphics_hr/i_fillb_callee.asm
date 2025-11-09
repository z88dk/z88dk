
; "Filled Box" on the ZX81, 256x384
; 2024 rework by Stefano Bodrato
;
; Usage: fillb(int tlx, int tly, int tlx2, int tly2)

    SECTION smc_clib

    PUBLIC  fillb_callee
    PUBLIC  _fillb_callee

    PUBLIC  asm_fillb

    EXTERN  leftbitmask
    EXTERN  rightbitmask
    EXTERN  l_cmp
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    EXTERN  w_pixeladdress
    INCLUDE "classic/gfx/grafix.inc"


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
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF

;    push    hl           ; width
    ld      (i_fillb_height+1),de
    
;    push    de
    exx  ; hl=x
         ; de=y

    ld      a,h                         ; chech for _GFX_MAXX
    and     a
    jp      nz, __graphics_end          ; Return if Y overflows
    
    push    hl
    ld      hl, _GFX_MAXY
    call    l_cmp
    pop     hl
    jp      nc, __graphics_end          ; Return if Y overflows

    push    de                          ; y addr
	ld      a,e
    ld      (cury+1), a

    push    hl                          ; x addr
    call    w_pixeladdress                ; bitpos0 = pixeladdress(x,y)
    ld      (clear_height+1),de          ; SMC: remember row addr
    call    leftbitmask                 ; LeftBitMask(bitpos0)
	cpl
    ld      (bitmaskl1+1), a            ; SMC
    ld      (bitmaskl2+1), a            ; SMC
    
    exx
    pop     bc                          ; x addr
    add     hl,bc
    ex      de,hl
    pop     bc                          ; y addr
    add     hl,bc
    ex      de,hl
    
    ld      a,h                         ; chech for _GFX_MAXX
    and     a
    jp      nz, __graphics_end          ; Return if Y overflows
    
    push    hl
    ld      hl, _GFX_MAXY
    call    l_cmp
    pop     hl
    jp      nc, __graphics_end          ; Return if Y overflows
    
    call    w_pixeladdress                ; bitpos1 = pixeladdress(x+width-1,y)
    call    rightbitmask                ; RightBitMask(bitpos1)
	cpl
    ld      (bitmaskr1+1), a
    ld      (bitmaskr2+1), a            ; bitmask1 = LeftBitMask(bitpos0)
    
    ld      hl,(clear_height+1)
    ex      de,hl
    and     a
    sbc     hl,de
    
    ld      a,l
    ld      (rowbytes1+1), a
    ld      (rowbytes2+1), a            ; rowbytes = (adr1-adr0) div 8, no. of bytes in row


       ; 0 means that area is within same address
       ; FOR h = 1 TO height

clear_height:
    ld      hl,0                        ; adr0

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
fill_row_loop:                         ; do
    ld      (hl), 255                     ; (offset) = 0
    inc     hl                          ; offset += 1 (8 bits)
    djnz    fill_row_loop              ; while ( r-- != 0 )
row_cleared:
    ld      a, (hl)                     ; byte = (adr1)
bitmaskr2:
    or      0
    ld      (hl), a                     ; preserve only rightmost side of byte (outside area)

clear_nextrow:
	   ld      hl,(clear_height+1)
cury:
       ld      a,0
       inc     a
       ld      (cury+1),a
       rra
       jr      nc,_oddrow2
       ld      de,6144
       jr      _evenrow2
_oddrow2:
       ld      de,-6144+32
_evenrow2:
       add     hl,de
	   ld      (clear_height+1),hl


       ; END FOR    h
i_fillb_height:
    ld      bc,0
    dec     bc
    ld      (i_fillb_height+1),bc
    ld      a,b
    or      c
    jp      z, __graphics_end
    jr      clear_height

