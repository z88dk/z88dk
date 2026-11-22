; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost2

PUBLIC asm_BIFROST2_stop

EXTERN _BIFROST2_ISR_STOP

asm_BIFROST2_stop:

   ld hl,_BIFROST2_ISR_STOP
   ld ($fdfe),hl
   
   ret
