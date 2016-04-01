; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_start()

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_start

EXTERN asm_BIFROST2_start

defc BIFROST2_start = asm_BIFROST2_start
