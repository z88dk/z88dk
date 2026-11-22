; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_resetAnim4Frames()

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_resetAnim4Frames

EXTERN asm_BIFROSTL_resetAnim4Frames

defc _BIFROSTL_resetAnim4Frames = asm_BIFROSTL_resetAnim4Frames
