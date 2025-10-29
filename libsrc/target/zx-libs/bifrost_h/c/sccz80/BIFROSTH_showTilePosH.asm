; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_showTilePosH(unsigned int lin,unsigned int col)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_showTilePosH

EXTERN asm_BIFROSTH_showTilePosH

BIFROSTH_showTilePosH:

        ld hl,2
        add hl,sp
        ld e,(hl)       ; E=col
        inc hl
        inc hl
        ld d,(hl)       ; D=lin

        jp asm_BIFROSTH_showTilePosH        ; execute 'show_tile_pos'
