; Usage: uncircle(int x, int y, int radius, int skip);


IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  uncircle
    PUBLIC  _uncircle

    EXTERN  asm_uncircle

.uncircle
._uncircle
    push    ix
    ld      ix,2
    add     ix,sp

;      de = x0, hl = y0, bc = radius, a = scale factor

    ld      a,(ix+2)    ;skip
    ld      c,(ix+4)    ;radius
    ld      b,(ix+5)
    ld      l,(ix+6)    ;y
    ld      h,(ix+7)
    ld      e,(ix+8)    ;x
    ld      d,(ix+9)
    pop     ix
    jp      asm_uncircle
ENDIF
