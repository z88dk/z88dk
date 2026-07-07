;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;    Compute the line coordinates and put into a vector
;    Basic concept by Rafael de Oliveira Jannone (calculate_side)
;
;     Stefano Bodrato - 13/3/2009
;
;
;    $Id: stencil_add_side.asm $
;

;; void stencil_add_side(int x1, int y1, int x2, int y2, unsigned char *stencil)


    SECTION code_graphics
    PUBLIC  stencil_add_side
    PUBLIC  _stencil_add_side

    EXTERN  Line
    EXTERN  stencil_add_pixel

    ; No paging required on the 'stencil' structures !
        ;EXTERN    __gfx_vram_page_in
        ;EXTERN    __gfx_vram_page_out

    EXTERN  stencil_ptr
    INCLUDE "classic/gfx/grafix.inc"

stencil_add_side:
_stencil_add_side:

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    push    ix
    ld      ix, 2
    add     ix, sp

    ld      l, (ix+2)                   ;pointer to stencil
    ld      h, (ix+3)
    ld      (stencil_ptr), hl

    ld      e, (ix+4)                   ;y1
    ld      d, (ix+6)                   ;x1
    ld      l, (ix+8)                   ;y0
    ld      h, (ix+10)                  ;x0

    ;call    __gfx_vram_page_in
    ld      ix, stencil_add_pixel
    call    Line
        ;jp    __graphics_end
    pop     ix
    ret

ELSE

    EXTERN  __plot_ADDR
    ld      hl,stencil_add_pixel
    ld      (__plot_ADDR),hl

    pop     af
    pop     hl
    ld      (stencil_ptr), hl

    pop     de                          ; y1
    pop     bc
    ld      d, c                        ; x1

    pop     hl                          ; y0
    pop     de                          ; x0

    push    de
    push    hl
    ld      h, e                        ; x0

    push    bc
    push    de                          ; foo value, the original value is gone

    push    hl
    push    af

    jp      Line

ENDIF

