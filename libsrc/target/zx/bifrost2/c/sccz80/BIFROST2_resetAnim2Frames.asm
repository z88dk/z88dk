; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_resetAnim2Frames(void)

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_resetAnim2Frames

EXTERN asm_BIFROST2_resetAnim2Frames

defc BIFROST2_resetAnim2Frames = asm_BIFROST2_resetAnim2Frames

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _BIFROST2_resetAnim2Frames
defc _BIFROST2_resetAnim2Frames = BIFROST2_resetAnim2Frames
ENDIF
