; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_resetTileImages(void *addr)
; fastcall

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_resetTileImages_fastcall

EXTERN asm_BIFROSTH_resetTileImages

defc _BIFROSTH_resetTileImages_fastcall = asm_BIFROSTH_resetTileImages
