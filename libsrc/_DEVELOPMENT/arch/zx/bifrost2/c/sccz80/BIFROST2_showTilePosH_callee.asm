; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_showTilePosH(unsigned int lin,unsigned int col)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_showTilePosH_callee

EXTERN asm_BIFROST2_showTilePosH

BIFROST2_showTilePosH_callee:

        pop hl          ; RET address
        pop de          ; E=col
        ex (sp),hl      ; L=lin
        ld d,l          ; D=lin

        jp asm_BIFROST2_showTilePosH        ; execute 'show_tile_pos'
