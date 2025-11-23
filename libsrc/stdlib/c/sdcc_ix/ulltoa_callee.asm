
; char *ulltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ulltoa_callee

EXTERN asm_ulltoa

_ulltoa_callee:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   pop bc
   exx
   pop bc
   push af
   
   exx
   push bc
   exx
   ex (sp),ix
   
   call asm_ulltoa
   
   pop ix
   ret
