;
;    z88dk GFX library
;
;    Render the "stencil".
;    The dithered horizontal lines base their pattern on the Y coordinate
;    and on an 'intensity' parameter (0..11).
;    Basic concept by Rafael de Oliveira Jannone
;    
;    Machine code version by Stefano Bodrato, 22/4/2009
;
;    stencil_render(unsigned char *stencil, unsigned char intensity)
;

    INCLUDE "graphics/grafix.inc"

    SECTION code_graphics
    PUBLIC  stencil_render
    PUBLIC  _stencil_render
    EXTERN  dither_pattern

    EXTERN  w_pixeladdress
    EXTERN  leftbitmask, rightbitmask
    EXTERN  __zx_screenmode
    EXTERN  __zx_console_attr
IF FORsam
    ; This code won't work on the same due to the lack of correct paging
    ; but it is assembled as part of zx-common 
    EXTERN  SCREEN_BASE
ENDIF

;    
;    $Id: w_stencil_render.asm,v 1.6 2016-07-14 17:44:17 pauloscustodio Exp $
;

.stencil_exit
    pop     ix
    ret

.stencil_render
._stencil_render
    push    ix
    ld      ix,4
    add     ix,sp

    ;call    swapgfxbk

    ld      bc,maxy
    push    bc
.yloop    
    pop     bc
    dec     bc
    ld      a,b
    and     c
    cp      255
    jr      z,stencil_exit
    push    bc
    
    ld      d,b
    ld      e,c

    ld      l,(ix+2)    ; stencil
    ld      h,(ix+3)

    add     hl,bc
    add     hl,bc
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    dec     hl

    ld      a,d    ; check left side for current Y position..
    and     e
    cp      127
    jr      z,yloop    ; ...loop if nothing to be drawn
    
    ld      bc,maxy*2
    add     hl,bc
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a

    pop     bc
    push    bc

    push    hl
    
    ld      a,(ix+0)    ; intensity
    push    de    ; X1
    call    dither_pattern
    pop     hl    ; X1
    ld      (pattern1+1),a
    ld      (pattern2+1),a

    push    bc
    ld      d,b
    ld      e,c
    call    w_pixeladdress    ; bitpos0 = pixeladdress(x,y)
    call    leftbitmask    ; LeftBitMask(bitpos0)
    pop     bc
    
    ld      h,d
    ld      l,e
    call    mask_pattern
    ex      (sp),hl    ; X2 <-> adr0
    push    af    ; mask

    ld      d,b
    ld      e,c

    push    bc
    call    w_pixeladdress    ; bitpos1 = pixeladdress(x+width-1,y)
    call    rightbitmask    ; RightBitMask(bitpos1)
    pop     bc
    ld      (bitmaskr+1),a    ; bitmask1 = LeftBitMask(bitpos0)

    pop     af    ; pattern to be drawn (left-masked)
    pop     hl    ; adr0
    ld      b,a
    
    ld      a,h
    cp      d
    jr      nz,noobt
    ld      a,l
    cp      e
    jr      z,onebyte
.noobt
    ld      a,b
    ld      (hl),a    ; (offset) = (offset) AND bitmask0
    call    nextcol

    ld      a,h
    cp      d
    jr      nz,pattern2
    ld      a,l
    cp      e
.pattern2    
    ld      a,0
    jr      z,bitmaskr
    ld      b,a
.fill_row_loop            ; do
    ld      a,b
    ld      (hl),a    ; (offset) = pattern
    call    nextcol
     
    ld      a,h
    cp      d
    jr      nz,fill_row_loop
    ld      a,l
    cp      e
    jr      nz,fill_row_loop    ; while ( r-- != 0 )

.bitmaskr   
    ld      a,0
    call    mask_pattern
    ld      (hl),a
    call    nextcol
    jp      yloop


.onebyte
    ld      a,b
    ld      (pattern1+1),a
    jr      bitmaskr


    ; Prepare an edge byte, basing on the byte mask in A
    ; and on the pattern being set in (pattern1+1)
.mask_pattern
    push    de
    ld      d,a    ; keep a copy of mask
    and     (hl)    ; mask data on screen
    ld      e,a    ; save masked data
    ld      a,d    ; retrieve mask
    cpl    ; invert it
.pattern1    
    and     0    ; prepare fill pattern portion
    or      e    ; mix with masked data
    pop     de
    ret

; Colour the pixel we were just on and step to the next column
nextcol:
    ld      a,(__zx_screenmode)
    cp      6
    jr      z,nextcol_hires     ;No colour in hires
    cp      2       ;High colour
    jr      nz,standard_modes
    set     5,h
    ld      a,(__zx_console_attr)
    ld      (hl),a
    res     5,h
    inc     hl
    ret
standard_modes:
    ; We are on a standard zx screen
    push    hl
    ld      a,h
    and     @00100000
    ld      c,a     ;Save page flag
    ld      a,h
    rrca
    rrca
    rrca
    and     3
IF FORsam
    or      +(SCREEN_BASE / 256) + 24
ELSE
    or      88
ENDIF
IF FORts2068|zxn
    or      c       ;Add in screen 1 bit
ENDIF
    ld      h,a
    ld      a,(__zx_console_attr)
    ld      (hl),a
    ; And increment the column
    pop     hl
    inc     hl
    ret

nextcol_hires:
    ld      a,h
    xor     @00100000
    cp      h
    ld      h,a
    ret     nc
    inc     hl
    ret
