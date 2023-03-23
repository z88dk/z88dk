
SECTION code_graphics

PUBLIC ___regis_savexy
PUBLIC ___regis_getx
PUBLIC ___regis_gety

EXTERN __gfx_coords

;void __regis_savexy(int x, int y) __z88dk_callee
___regis_savexy:
    pop     bc
    pop     hl
    ld      (__gfx_coords+2),hl
    pop     hl
    ld      (__gfx_coords),hl
    push    bc
    ret

;int __regis_getx()
___regis_getx:
    ld      hl,(__gfx_coords)
    ret

___regis_gety:
    ld      hl,(__gfx_coords + 2)
    ret

