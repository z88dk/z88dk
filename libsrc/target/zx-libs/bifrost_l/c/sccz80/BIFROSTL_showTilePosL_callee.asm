; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_showTilePosL(unsigned int row, unsigned int col)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_showTilePosL_callee

EXTERN asm_BIFROSTL_showTilePosL

BIFROSTL_showTilePosL_callee:

        pop hl          ; RET address
        pop de          ; E=col
        ex (sp),hl      ; L=row
        ld d,l          ; D=row

        jp asm_BIFROSTL_showTilePosL        ; execute 'show_tile_pos'
