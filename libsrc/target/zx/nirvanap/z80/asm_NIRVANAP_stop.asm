SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_stop

EXTERN _NIRVANAP_ISR_STOP

asm_NIRVANAP_stop:

   ld hl,_NIRVANAP_ISR_STOP
   ld ($fdfe),hl
   
   ret
