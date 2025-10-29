
; size_t dtoh(double x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC dtoh_callee

EXTERN dcallee1, asm_dtoh

dtoh_callee:

   pop af
   pop bc
   pop de
   pop hl
   push af
   
   call dcallee1
   
   jp asm_dtoh
