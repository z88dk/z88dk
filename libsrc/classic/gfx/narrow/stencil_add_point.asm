;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;    Put a pixel in the stencil vectors
;
;     Stefano Bodrato - 08/10/2009
;
;
;    $Id: stencil_add_point.asm $
;

;; void stencil_add_point(int x, int y, unsigned char *stencil)


    SECTION code_graphics
    PUBLIC  stencil_add_point
    PUBLIC  _stencil_add_point

    EXTERN  stencil_add_pixel

    ; No paging required on the 'stencil' structures !
        ;EXTERN    __gfx_vram_page_in
        ;EXTERN    __gfx_vram_page_out

    EXTERN  stencil_ptr
    INCLUDE "classic/gfx/grafix.inc"

stencil_add_point:
_stencil_add_point:

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    push    ix
    ld      ix, 2
    add     ix, sp

    ld      l, (ix+2)                   ;pointer to stencil
    ld      h, (ix+3)
    ld      (stencil_ptr), hl

    ;ld    l,(ix+4)    ;pointer to leftmost vector
    ;ld    h,(ix+5)
    ;ld    (gfx_area),hl

    ld      l, (ix+4)                   ;y0
    ld      h, (ix+6)                   ;x0

    pop     ix

ELSE

    pop     af
    pop     hl
    ld      (stencil_ptr), hl

    pop     de                          ; y
    pop     hl                          ; x
    ld      d,l
    
    push    hl
    push    de

    push    hl
    push    af

ENDIF

    jp      stencil_add_pixel
