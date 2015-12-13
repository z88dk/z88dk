; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_resetAnim2Frames(void)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_resetAnim2Frames

EXTERN asm_BIFROSTH_resetAnim2Frames

defc _BIFROSTH_resetAnim2Frames = asm_BIFROSTH_resetAnim2Frames
