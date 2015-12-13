; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_disableSprites(void)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_disableSprites

EXTERN asm_BIFROSTH_disableSprites

defc BIFROSTH_disableSprites = asm_BIFROSTH_disableSprites
