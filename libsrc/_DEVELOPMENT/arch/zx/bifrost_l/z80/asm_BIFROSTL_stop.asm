; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost_l

PUBLIC asm_BIFROSTL_stop

EXTERN _BIFROSTL_ISR_HOOK

asm_BIFROSTL_stop:

   ld hl,_BIFROSTL_ISR_HOOK
   ld ($fdfe),hl
   
   ret
