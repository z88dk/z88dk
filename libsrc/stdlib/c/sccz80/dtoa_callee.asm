
; size_t dtoa(double x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC dtoa_callee

EXTERN dcallee1, asm_dtoa

dtoa_callee:

   pop af
   pop bc
   pop de
   pop hl
   push af
   
   call dcallee1
   
   jp asm_dtoa
