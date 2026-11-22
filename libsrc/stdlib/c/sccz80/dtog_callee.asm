
; size_t dtog(double x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC dtog_callee

EXTERN dcallee1, asm_dtog

dtog_callee:

   pop af
   pop bc
   pop de
   pop hl
   push af
   
   call dcallee1
   
   jp asm_dtog
