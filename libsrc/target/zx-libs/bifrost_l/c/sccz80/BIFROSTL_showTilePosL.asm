; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_showTilePosL(unsigned int row, unsigned int col)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_showTilePosL

EXTERN asm_BIFROSTL_showTilePosL

BIFROSTL_showTilePosL:

        ld hl,2
        add hl,sp
        ld e,(hl)       ; E=col
        inc hl
        inc hl
        ld d,(hl)       ; D=row

        jp asm_BIFROSTL_showTilePosL        ; execute 'show_tile_pos'
