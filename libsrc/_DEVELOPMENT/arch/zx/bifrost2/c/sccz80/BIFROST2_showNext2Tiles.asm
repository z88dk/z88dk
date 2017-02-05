; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_showNext2Tiles(void)

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_showNext2Tiles

EXTERN asm_BIFROST2_showNext2Tiles

defc BIFROST2_showNext2Tiles = asm_BIFROST2_showNext2Tiles
