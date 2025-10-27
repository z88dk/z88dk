; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROST_stop()

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_stop

EXTERN asm_BIFROSTH_stop

defc BIFROSTH_stop = asm_BIFROSTH_stop
