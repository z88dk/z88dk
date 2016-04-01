; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_showTilePosH(unsigned int lin,unsigned int col)

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_showTilePosH

EXTERN asm_BIFROST2_showTilePosH

BIFROST2_showTilePosH:

        ld hl,2
        add hl,sp
        ld e,(hl)       ; E=col
        inc hl
        inc hl
        ld d,(hl)       ; D=lin

        jp asm_BIFROST2_showTilePosH        ; execute 'show_tile_pos'
