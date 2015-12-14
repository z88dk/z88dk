; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_resetAnim2Frames()

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_resetAnim2Frames

EXTERN asm_BIFROSTL_resetAnim2Frames

defc BIFROSTL_resetAnim2Frames = asm_BIFROSTL_resetAnim2Frames
