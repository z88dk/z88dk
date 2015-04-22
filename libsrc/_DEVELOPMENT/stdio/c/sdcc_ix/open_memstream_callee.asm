
; FILE *open_memstream_callee(char **bufp, size_t *sizep)

SECTION code_stdio

PUBLIC _open_memstream_callee, l0_open_memstream_callee

_open_memstream_callee:

   pop hl
   pop de
   ex (sp),hl

l0_open_memstream_callee:

   push ix
   
   call asm_open_memstream
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_open_memstream.asm"
