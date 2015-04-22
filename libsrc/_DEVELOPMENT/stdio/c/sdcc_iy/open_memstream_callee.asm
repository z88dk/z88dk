
; FILE *open_memstream_callee(char **bufp, size_t *sizep)

SECTION code_stdio

PUBLIC _open_memstream_callee

_open_memstream_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_open_memstream.asm"
