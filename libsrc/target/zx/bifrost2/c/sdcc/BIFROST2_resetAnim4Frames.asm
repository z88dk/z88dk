; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_resetAnim4Frames(void)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_resetAnim4Frames

EXTERN asm_BIFROST2_resetAnim4Frames

defc _BIFROST2_resetAnim4Frames = asm_BIFROST2_resetAnim4Frames
