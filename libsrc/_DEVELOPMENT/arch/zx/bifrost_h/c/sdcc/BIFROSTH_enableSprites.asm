; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_enableSprites(void)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_enableSprites

EXTERN asm_BIFROSTH_enableSprites

defc _BIFROSTH_enableSprites = asm_BIFROSTH_enableSprites
