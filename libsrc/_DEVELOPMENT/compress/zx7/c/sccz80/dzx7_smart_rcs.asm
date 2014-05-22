
; void dzx7_smart_rcs(void *src, void *dst)

PUBLIC dzx7_smart_rcs

EXTERN asm_dzx7_smart_rcs

dzx7_smart_rcs:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx7_smart_rcs
