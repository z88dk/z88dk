; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_resetTileImages(void *addr)
; fastcall

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_resetTileImages_fastcall

EXTERN asm_BIFROSTL_resetTileImages

defc _BIFROSTL_resetTileImages_fastcall = asm_BIFROSTL_resetTileImages
