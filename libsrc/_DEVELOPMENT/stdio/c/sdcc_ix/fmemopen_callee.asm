
; FILE *fmemopen_callee(void *buf, size_t size, const char *mode)

SECTION code_stdio

PUBLIC _fmemopen_callee, l0_fmemopen_callee

_fmemopen_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af

l0_fmemopen_callee:

   push ix
   
   call asm_fmemopen
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fmemopen.asm"
