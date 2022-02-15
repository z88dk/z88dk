;
;    z88dk GFX library
;    Render the "stencil" - plot/unplot based 'wide rez' version.
;      Stefano - Apr 2017
;
;    The dithered horizontal lines base their pattern on the Y coordinate
;    and on an 'intensity' parameter (0..11).
;    Basic concept by Rafael de Oliveira Jannone
;    
;    stencil_render(unsigned char *stencil, unsigned char intensity)
;

    INCLUDE    "graphics/grafix.inc"

IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC    __generic_stencil_render
    EXTERN    dither_pattern

    EXTERN w_plotpixel
    EXTERN w_respixel
    EXTERN    __gfx_coords
    
    EXTERN swapgfxbk
    EXTERN    __graphics_end


;    
;    $Id: w_stencil_render2.asm, 2017 -  stefano Exp $
;

.__generic_stencil_render
    push    ix    ;save callers
    ld    ix,4
    add    ix,sp
IF NEED_swapgfxbk = 1
     call    swapgfxbk
ENDIF
    ld    bc,maxy
    ld    hl,(__gfx_coords)
    push    hl
    ld    de,(__gfx_coords+2)
    push    de
    push    bc

.yloop
    pop    bc
    dec    bc
    ld    a,b
    and    c
    cp 255
    jr    nz,noret
    pop    de
    ld    (__gfx_coords+2),de
    pop    hl
    ld    (__gfx_coords),hl
    jp __graphics_end
.noret
    push    bc

    ld    l,(ix+2)    ; stencil
    ld    h,(ix+3)

    add    hl,bc    ; find the current X1 position on the left Y vector
    add    hl,bc
    ld    e,(hl)
    inc hl
    ld    d,(hl)    ; DE=X1
    dec hl
    ;ex    (sp),hl

    ld    a,d        ; check left side for current Y position..
    and    e
    cp    127
    jr    z,yloop    ; ...loop if nothing to be drawn
    
    ld    bc,maxy*2    ; for X2, shift to the right Y vector
    add    hl,bc
    ld    a,(hl)
    inc hl
    ld    h,(hl)
    ld    l,a        ; HL=X2
    
    ex    de,hl    ; HL=X1, DE=X2
    inc de
    inc de

    pop bc
    push bc

    ld    a,(ix+0)    ; intensity
    push hl
    push de
    push hl
    call    dither_pattern
    pop hl
    ld    h,a
    ld    a,l
    and 7
.pattern_shift
    rrc h    ; shifted pattern
    dec a
    jr nz,pattern_shift
    ld    a,h
    pop de
    pop hl
        

.xloop

    rrca
    push    hl
    push    de
    push    bc
    push    af
    ld    d,b
    ld    e,c

jr    nc,do_unplot
        call    w_plotpixel
        jp    done
.do_unplot
        call    w_respixel    
.done
    pop af
    pop bc
    pop de
    pop hl
    
    inc hl    ; X1++
    
    push af
    ld    a,h        ; Compare X1 and X2
    cp    d
    jp    nz, in_row
    ld    a,l
    cp    e
    jp    nz,    in_row
    pop af
    jp    yloop        ; next row if equal

.in_row
    pop    af
    jp    xloop        ; otherwise, loop
ENDIF
