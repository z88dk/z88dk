;
;     Z88 Graphics Functions - Small C+ stubs
; Usage: xorcircle(int x, int y, int radius, int skip);


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  xorcircle
    PUBLIC  _xorcircle

    EXTERN  asm_xorcircle


.xorcircle
._xorcircle
    push    ix
    ld      ix,2
    add     ix,sp
    ld      e,(ix+2)    ;skip
    ld      d,(ix+4)    ;radius
    ld      c,(ix+6)    ;y
    ld      b,(ix+8)    ;x
    jp      asm_xorcircle
ENDIF
