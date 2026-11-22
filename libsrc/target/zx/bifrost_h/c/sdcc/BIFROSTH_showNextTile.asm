; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_showNextTile(void)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_showNextTile

EXTERN asm_BIFROSTH_showNextTile

defc _BIFROSTH_showNextTile = asm_BIFROSTH_showNextTile
