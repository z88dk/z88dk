;Usage: xorclga(struct *pixels)

IF !__CPU_INTEL__ & !__CPU_GBZ80__

    SECTION code_graphics
    
    PUBLIC  xorclga
    PUBLIC  _xorclga
    
    EXTERN  asm_xorclga
    
.xorclga
._xorclga
    push    ix
    ld      ix,2
    add     ix,sp
    ld      c,(ix+2)
    ld      b,(ix+4)
    ld      l,(ix+6)
    ld      h,(ix+8)
    pop     ix
    jp      asm_xorclga
ENDIF
