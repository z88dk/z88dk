; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_fillTileAttrL(unsigned int row, unsigned int col, unsigned int attr)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_fillTileAttrL_callee

EXTERN asm_BIFROSTL_fillTileAttrL

_BIFROSTL_fillTileAttrL_callee:

        pop hl          ; RET address
        pop bc          ; C=row
        pop de          ; E=col
        ld d,c          ; D=row
        pop bc          ; C=attrib
        push hl           

        jp asm_BIFROSTL_fillTileAttrL        ; execute 'fill_tile_attr'
