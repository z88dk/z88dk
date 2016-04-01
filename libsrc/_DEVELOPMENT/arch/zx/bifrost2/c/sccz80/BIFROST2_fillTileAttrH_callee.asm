; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_fillTileAttrH(unsigned int lin,unsigned int col,unsigned int attr)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_fillTileAttrH_callee

EXTERN asm_BIFROST2_fillTileAttrH

BIFROST2_fillTileAttrH_callee:

        pop hl          ; RET address
        pop bc          ; C=attrib
        pop de          ; E=col
        ex (sp),hl      ; L=lin
        ld d,l          ; D=lin

        jp asm_BIFROST2_fillTileAttrH        ; execute 'fill_tile_attr'
