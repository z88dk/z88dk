; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROST_stop(void)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_stop

EXTERN asm_BIFROSTH_stop

defc _BIFROSTH_stop = asm_BIFROSTH_stop
