;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;    Trace a relative line in the stencil vectors
;
;     Stefano Bodrato - 08/10/2009
;
;
;    $Id: stencil_add_lineto.asm, $
;

;; void stencil_add_lineto(int x, int y, unsigned char *stencil)


    SECTION code_graphics
    PUBLIC  stencil_add_lineto
    PUBLIC  _stencil_add_lineto

    EXTERN  Line
    EXTERN  stencil_add_pixel

    EXTERN  __gfx_coords

    ; No paging required on the 'stencil' structures !
        ;EXTERN    __gfx_vram_page_in
        ;EXTERN    __gfx_vram_page_out

    EXTERN  stencil_ptr
    ;EXTERN    __graphics_end
    INCLUDE "classic/gfx/grafix.inc"

stencil_add_lineto:
_stencil_add_lineto:

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    push    ix
    ld      ix, 2
    add     ix, sp

    ld      l, (ix+2)                   ;pointer to stencil
    ld      h, (ix+3)
    ld      (stencil_ptr), hl

    ld      hl, (__gfx_coords)
    ld      e, (ix+4)                   ;y1
    ld      d, (ix+6)                   ;x1

    ;call    __gfx_vram_page_in

    ld      ix, stencil_add_pixel
    call    Line

        ;jp    __graphics_end
    pop     ix
    ret

ELSE

    pop     af
    pop     hl
    ld      (stencil_ptr), hl

    pop     de                          ; y
    pop     hl                          ; x
	ld      d,l
	
    ld      hl, (__gfx_coords)

    push    hl
    push    de

    push    hl
    push    af

    jp      Line

ENDIF

