; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_stop()

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_stop

EXTERN asm_BIFROSTL_stop

defc _BIFROSTL_stop = asm_BIFROSTL_stop
