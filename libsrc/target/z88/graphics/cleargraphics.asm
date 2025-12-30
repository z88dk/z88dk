

SECTION code_clib
PUBLIC  cleargraphics

EXTERN  __z88_gfxmode
EXTERN  base_graphics



; No need to do paging - clg does it
cleargraphics:
    ld      hl,(base_graphics)
    ld      de,hl
    inc     de
    ld      bc,+(32*8*8)-1
    ld      a,(__z88_gfxmode)
    and     a
    jr      z,doit
    ld      bc,+(64*8*8)-1
doit:
    ldir
    ret





