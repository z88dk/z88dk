;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: window.asm,v 1.3 2016-05-17 21:43:06 dom Exp $
;

;       This function will open a window of any type (graphics/text)
;       on the Z88 screen, graphics flag states gfx or text
;

;Usage: window(struct *windst)
;
;These are offset by 32 as per usual on a z88.
;
;struct window {
;       char windnumber;
;       char x;
;       char y;
;       char width;
;       char depth;
;       char type;
;       char graphics;  0=text, 1=graphics, 2=graphics 512
;} ;

    INCLUDE "classic/gfx/grafix.inc"       ; Contains fn defs

    INCLUDE "stdio.def"
    INCLUDE "map.def"
    INCLUDE "screen.def"

    SECTION code_clib

    PUBLIC  window
    PUBLIC  _window

    EXTERN  base_graphics
    EXTERN  __z88_gfxbank
    EXTERN  z88_map_segment
    EXTERN  __z88_gfxmode
    EXTERN  z88_map_bank

window:
_window:
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    ix                          ;save ix
    push    hl
    pop     ix
;ix is address of struct..
    ld      a, (ix+graph)
    and     a
    jr      nz, opengfx

    ld      hl, initwind
    call_oz (gn_sop)
    push    ix
    pop     hl
    call_oz (gn_sop)
    ld      hl, 0                       ;All good, return NULL
    pop     ix
    ret



opengfx:
    dec     a
    ld      (__z88_gfxmode),a
    jr      nz,open_512
    ld      l, (ix+wind_w)
    ld      h, 0
    ld      a, l
    and     a
    ld      a, (ix+windnum)             ;window number
    ld      bc, mp_def                  ;define map based on pipedream
    jr      z, opengfx1
    ld      bc, mp_gra                  ;user width
opengfx1:
    call_oz (os_map)                    ;opened the window
    ld      hl, 1
    jr      c, opengfx_exit             ;error, return TRUE
setup_map_addresses:
    ;Now get the address of the map
    ld      b, 0                        ; query
    ld      a, sc_hr0
    call_oz (os_sci)                    ; get base address of map area (hires0)
    ld      a, b
    ld      (__z88_gfxbank), a
    ld      a, h
    and     63                          ;mask to bank
    or      z88_map_segment             ;mask to segment map_seg
    ld      h, a
    ld      (base_graphics), hl
    ld      hl, 0                       ;NULL=good
opengfx_exit:
    pop     ix
    ret


open_512:
    ; Get the SBR 
    ld      b, 0                        ; get the details
    ld      a, sc_sbr
    call_oz (os_sci)                    ; get base address of map area (hires0)
   
    ; Page in the bamk for SBR
    ld      a,h
    and     63
    or      z88_map_segment
    ld      h,a

    ld      a,(z88_map_bank)
    push    af
    ld      a,b
    ld      (z88_map_bank),a
    out     (z88_map_bank-$400), a


    ; Now setup a graphics display that's 512 bytes wide
    ld      l,36
    ld      b,8
    ld      d,0x20
    ld      e,0
row_loop:
    push    bc
    push    hl
    ld      b,64
row_fill:
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    inc     de
    djnz    row_fill

    ; There are 216 bytes to fill, we want to leave the last 3 (OZ panel) in place
    ld      b,+(216-128-36 - 6) / 2
null_fill:
    ld      (hl),$0
    inc     hl
    ld      (hl),$34
    inc     hl
    djnz    null_fill
    pop     hl
    inc     h      ;step to next row
    pop     bc
    djnz    row_loop
    
    ; Restore banking
    pop     af
    ld      (z88_map_bank),a
    out     (z88_map_bank-$400), a
    jr      setup_map_addresses



    SECTION rodata_clib
initwind:
    defb    1, '7', '#', 0


