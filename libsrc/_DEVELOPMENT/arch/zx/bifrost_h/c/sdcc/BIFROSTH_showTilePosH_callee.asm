; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_showTilePosH(unsigned int lin,unsigned int col)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_showTilePosH_callee

EXTERN asm_BIFROSTH_showTilePosH

_BIFROSTH_showTilePosH_callee:

        pop hl          ; RET address
        pop bc          ; C=lin
        pop de          ; E=col
        push hl
        ld d,c          ; D=lin

        jp asm_BIFROSTH_showTilePosH        ; execute 'show_tile_pos'
