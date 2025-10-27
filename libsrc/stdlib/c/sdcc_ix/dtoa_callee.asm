
; size_t dtoa(double x, char *buf, uint16_t prec, uint16_t flag) __z88dk_callee

SECTION code_clib
SECTION code_stdlib

PUBLIC _dtoa_callee, l0_dtoa_callee

EXTERN dcallee1, asm_dtoa

_dtoa_callee:

   call dcallee1               ; AC' = x
   
   pop af
   pop hl
   pop de
   pop bc
   push af

l0_dtoa_callee:

   push ix
   
   call asm_dtoa
   
   pop ix
   ret
