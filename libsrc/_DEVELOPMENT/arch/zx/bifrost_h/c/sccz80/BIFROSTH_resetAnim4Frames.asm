; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_resetAnim4Frames(void)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_resetAnim4Frames

EXTERN asm_BIFROSTH_resetAnim4Frames

defc BIFROSTH_resetAnim4Frames = asm_BIFROSTH_resetAnim4Frames
