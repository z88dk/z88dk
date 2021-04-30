;Usage: clga(int tlx, int tly, int tlx2, int tly2)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  clga
    PUBLIC  _clga
    
    EXTERN  asm_clga

.clga
._clga
    push    ix
    ld      ix,2
    add     ix,sp
    ld      c,(ix+2)
    ld      b,(ix+4)
    ld      l,(ix+6)
    ld      h,(ix+8)
    pop     ix
    jp      asm_clga
ENDIF
