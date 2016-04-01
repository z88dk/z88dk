; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void void BIFROST2_fillTileAttrH(unsigned int lin,unsigned int col,unsigned int attr)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_fillTileAttrH_callee

EXTERN asm_BIFROST2_fillTileAttrH

_BIFROST2_fillTileAttrH_callee:

        pop hl          ; RET address
        pop bc          ; C=lin
        pop de          ; E=col
        ld d,c          ; D=lin
        pop bc          ; C=attrib
        push hl

        jp asm_BIFROST2_fillTileAttrH        ; execute 'fill_tile_attr'
