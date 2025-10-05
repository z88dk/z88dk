; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROST_start()

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_start

EXTERN asm_BIFROSTL_start

defc BIFROSTL_start = asm_BIFROSTL_start
