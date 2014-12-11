
; FILE *fmemopen(void *buf, size_t size, const char *mode)

SECTION code_stdio

PUBLIC _fmemopen

_fmemopen:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   push ix
   
   call asm_fmemopen
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fmemopen.asm"
