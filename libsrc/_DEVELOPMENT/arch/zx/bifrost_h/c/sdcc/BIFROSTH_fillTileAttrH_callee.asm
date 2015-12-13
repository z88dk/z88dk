; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void void BIFROSTH_fillTileAttrH(unsigned int lin,unsigned int col,unsigned int attr)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_fillTileAttrH_callee

EXTERN asm_BIFROSTH_fillTileAttrH

_BIFROSTH_fillTileAttrH_callee:

        pop hl          ; RET address
        pop bc          ; C=lin
        pop de          ; E=col
        ld d,c          ; D=lin
        pop bc          ; C=attrib
        push hl

        jp asm_BIFROSTH_fillTileAttrH        ; execute 'fill_tile_attr'
