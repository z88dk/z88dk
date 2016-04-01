; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_resetTileImages(void *addr)

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_resetTileImages

EXTERN asm_BIFROST2_resetTileImages

defc BIFROST2_resetTileImages = asm_BIFROST2_resetTileImages
