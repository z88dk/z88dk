
SECTION code_clib
PUBLIC  agon_set_palette
PUBLIC  _agon_set_palette
PUBLIC  ___agon_set_palette


INCLUDE "target/agon/def/mos_api.inc"

defc _agon_set_palette = agon_set_palette
defc ___agon_set_palette = agon_set_palette

; agon_set_palette(int pen, int pindex, int r, int g, int b)
agon_set_palette:
    push     ix
    ld       ix,2
    add      ix,sp
    ld       a,0x13	;VDU palette
    AGONPUTC
    ld       a,(ix+10)  ;pen
    AGONPUTC
    ld       a,(ix+8)  ;pindex
    AGONPUTC
    ld       a,(ix+6)  ;r
    AGONPUTC
    ld       a,(ix+4)  ;g
    AGONPUTC
    ld       a,(ix+2)  ;b
    AGONPUTC
    ret

	
   
