
SECTION code_graphics

PUBLIC ___tek_savexy
PUBLIC ___tek_getx
PUBLIC ___tek_gety

EXTERN __gfx_coords

;void __tek_savexy(int x, int y) __z88dk_callee
___tek_savexy:
    pop     bc
    pop     hl
    ld      (__gfx_coords+2),hl
    pop     hl
    ld      (__gfx_coords),hl
    push    bc
    ret

;int __tek_getx()
___tek_getx:
    ld      hl,(__gfx_coords)
    ret

___tek_gety:
    ld      hl,(__gfx_coords + 2)
    ret

