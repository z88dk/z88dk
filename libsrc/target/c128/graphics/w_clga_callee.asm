;
;       Graphics routines for the Commodore 128
;       2024 rework by Stefano Bodrato
;
; Usage: clga(int tlx, int tly, int tlx2, int tly2)
;

     SECTION smc_clib

    PUBLIC  clga_callee
    PUBLIC  _clga_callee

    PUBLIC  asm_clga

    EXTERN  w_pixeladdress
    EXTERN  leftbitmask, rightbitmask
    EXTERN  __c128_vaddr
;;    EXTERN  __gfx_fatpix
    EXTERN  _vdcDispMem

    EXTERN  l_cmp
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


clga_callee:
_clga_callee:

    pop     af  ; ret addr
    pop     de  ; tly2
    pop     hl  ; tlx2
    exx                                 ; w_plotpixel and __gfx_vram_page_in must not use the alternate registers, no problem with w_line_r
    pop     de  ; tly1
    pop     hl  ; tlx1
    push    af                          ; ret addr
    exx

asm_clga:

    push    ix
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF


;    push    hl           ; width
    ld      (c128_clga_height+1),de
    
    exx  ; hl=x
         ; de=y

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
    call    w_pixeladdress                ; bitpos0 = pixeladdress(x,y)
    ld      (clear_main+1),de           ; SMC: set start location on display
    call    leftbitmask                 ; LeftBitMask(bitpos0)
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

    call    w_pixeladdress                ; bitpos1 = pixeladdress(x+width-1,y)
    call    rightbitmask                ; RightBitMask(bitpos1)
    ld      (bitmaskr1+1), a
    ld      (bitmaskr2+1), a            ; bitmask1 = LeftBitMask(bitpos0)
    
    ld      de,(clear_main+1)
    and     a
    sbc     hl,de
    
    ld      (rowbytes1+1), hl
    ld      (rowbytes2+1), hl            ; rowbytes = (adr1-adr0) div 8, no. of bytes in row


       ; 0 means that area is within same address
       ; FOR h = 1 TO height

clear_main:
    ld      hl,0                        ; adr0

;-------------------
rowbytes1:
    ld      bc,0
    ld      a,b
    or      c                           ; if rowbytes = 0
    jr      nz, clear_row               ; area is within one byte...

;-------------------
; Single byte 
    call    ldahl
bitmaskl1:
    and     0                           ; preserve bits of leftmost side of byte
    ld      b, a
    call    ldahl
bitmaskr1:
    and     0                           ; preserve bits of rightmost side of byte
    or      b                           ; merge preserved bits of left side
    call    ldhla                     ; (offset) = byte
    jr      clear_nextrow               ; else

; Multi-byte
;-------------------
clear_row:                              ; clear area is defined as rows of bytes
    call    ldahl
bitmaskl2:
    and     0                           ; preserve only leftmost bits (outside of area)
    call    ldhla                     ; (offset) = (offset) AND bitmask0
    inc     hl                          ; offset += 1 (8 bits)
rowbytes2:
    ld      bc, 0                        ; r = rowbytes
    dec     bc                           ; --r
    ld      a,b
    or      c
    jr      z, row_cleared              ; if    ( r )
clear_row_loop:                         ; do
    xor     a
    call    ldhla                     ; (offset) = 0
    inc     hl                          ; offset += 1 (8 bits)
    dec     bc                           ; --r
    ld      a,b
    or      c
    jr      nz, clear_row_loop              ; while ( r-- != 0 )
row_cleared:
    call    ldahl                     ; byte = (adr1)
bitmaskr2:
    and     0
    call    ldhla                     ; preserve only rightmost side of byte (outside area)

;-------------------
clear_nextrow:
       ld      hl,(clear_main+1)
       ld      de,80
       add     hl,de
       ld      (clear_main+1),hl

;;;   check for Y + Ysz overflow
;;	ex      de,hl
;;  ld      hl, (_vdcDispMem)
;;	ld      bc, _GFX_MAXY*80
;;	add	    hl,bc
;;	sbc	    hl,de
;;	bit     7,h
;;  jp      nz, __graphics_end


       ; END FOR    h
c128_clga_height:
    ld      bc,0
    dec     bc
    ld      (c128_clga_height+1),bc
    ld      a,b
    or      c
    jp      z, __graphics_end
    jr      clear_main

;-------------------------

;; vpoke (de),a
ldhla:
    push    bc
    call    __c128_vaddr
    out     (c), a
    pop     bc
    ret


;; vpeek a,(de)
ldahl:
    push    bc
    call    __c128_vaddr
    in     a,(c)
    pop     bc
    ret

