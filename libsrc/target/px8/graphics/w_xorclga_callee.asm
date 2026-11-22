
;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;
;	$Id: w_xorclga_callee.asm $
;


;Usage: xorclga(struct *pixels)

    SECTION code_graphics

    PUBLIC  xorclga_callee
    PUBLIC  _xorclga_callee

    PUBLIC  asm_xorclga

    EXTERN  w_area

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end


xorclga_callee:
_xorclga_callee:

    pop     af

    pop     de
    pop     hl
    exx                                 ; w_plotpixel and __gfx_vram_page_in must not use the alternate registers, no problem with w_line_r
    pop     de
    pop     hl

    push    af                          ; ret addr

    exx

asm_xorclga:

    ld      a, 3
    jp      w_area
