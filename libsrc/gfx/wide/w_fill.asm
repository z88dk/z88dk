;      Z88DK Small C+ Graphics Functions
;      Fills a screen area
;
;    Generic and simple version, slower and wasting a bit of memory
;
;    $Id: w_fill.asm $
;

    INCLUDE    "graphics/grafix.inc"


IF !__CPU_INTEL__ && !__CPU_GBZ80__
    MODULE    w_fill
    SECTION        code_graphics

    PUBLIC    fill
    PUBLIC    _fill

    EXTERN    l_graphics_cmp

    EXTERN   point
    EXTERN   plot
    EXTERN    getmaxx
    EXTERN    getmaxy


;ix points to the table on stack (above)

;Entry:
;      hl=x0 de=y0

;fill(int x, int y)
;{
;    if (!point(x,y)) {
;       plot(x, y);
;       fill(x+1, y);
;       fill(x-1, y);
;       fill(x, y+1);
;       fill(x, y-1);
;    }
;}

.fill
._fill
    pop bc
    pop de  ; y
    pop hl  ; x
    push hl
    push de
    push bc
    
    push    hl
    call    getmaxy
    call    l_graphics_cmp
    pop    hl
    ret    nc            ; Return if Y overflows

    push    de
    ex    de,hl
    call    getmaxx
    call    l_graphics_cmp
    ex    de,hl
    pop    de
    ret    nc            ; Return if X overflows
    
    push    hl
    push    de
    call    point
    pop    de
    pop    hl
    
    ret    nz
    
    ;    -- -- -- -- -- -- -- --
    
    push    hl
    push    de
    call    plot
    pop    de
    pop    hl
    
    inc    hl
    
    push    hl
    push    de
    call    fill
    pop    de
    pop    hl

    dec    hl
    dec    hl
    
    push    hl
    push    de
    call    fill
    pop    de
    pop    hl

    inc    hl
    inc    de
    
    push    hl
    push    de
    call    fill
    pop    de
    pop    hl

    dec    de
    dec    de
    
    push    hl
    push    de
    call    fill
    pop    de
    pop    hl
    
    ret

ENDIF
