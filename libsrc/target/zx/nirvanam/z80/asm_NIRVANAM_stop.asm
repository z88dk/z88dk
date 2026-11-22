SECTION code_clib
SECTION code_nirvanam

PUBLIC asm_NIRVANAM_stop

EXTERN _NIRVANAM_ISR_STOP

asm_NIRVANAM_stop:

   ld hl,_NIRVANAM_ISR_STOP
   ld ($fdfe),hl
   
   ret
