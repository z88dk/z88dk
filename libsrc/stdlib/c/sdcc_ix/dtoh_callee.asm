
; size_t dtoh(double x, char *buf, uint16_t prec, uint16_t flag) __z88dk_callee

SECTION code_clib
SECTION code_stdlib

PUBLIC _dtoh_callee, l0_dtoh_callee

EXTERN dcallee1, asm_dtoh

_dtoh_callee:

   call dcallee1               ; AC' = x
   
   pop af
   pop hl
   pop de
   pop bc
   push af

l0_dtoh_callee:

   push ix
   
   call asm_dtoh
   
   pop ix
   ret
