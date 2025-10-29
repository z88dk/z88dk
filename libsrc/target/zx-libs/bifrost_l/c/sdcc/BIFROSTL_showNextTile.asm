; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_showNextTile()

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTL_showNextTile

EXTERN asm_BIFROSTL_showNextTile

defc _BIFROSTL_showNextTile = asm_BIFROSTL_showNextTile
