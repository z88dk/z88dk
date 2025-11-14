; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_showNextTile(void)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_showNextTile

EXTERN asm_BIFROST2_showNextTile

defc _BIFROST2_showNextTile = asm_BIFROST2_showNextTile
