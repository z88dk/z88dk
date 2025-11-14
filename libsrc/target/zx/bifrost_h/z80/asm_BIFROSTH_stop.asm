; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost_h

PUBLIC asm_BIFROSTH_stop

EXTERN _BIFROSTH_ISR_HOOK

asm_BIFROSTH_stop:

   ld hl,_BIFROSTH_ISR_HOOK
   ld ($fdfe),hl
   
   ret
