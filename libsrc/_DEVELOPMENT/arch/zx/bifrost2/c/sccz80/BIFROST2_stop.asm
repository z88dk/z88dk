; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_stop()

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_stop

EXTERN asm_BIFROST2_stop

defc BIFROST2_stop = asm_BIFROST2_stop
