; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_resetTileImages(void *addr)
; fastcall

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_resetTileImages_fastcall

EXTERN asm_BIFROST2_resetTileImages

defc _BIFROST2_resetTileImages_fastcall = asm_BIFROST2_resetTileImages
