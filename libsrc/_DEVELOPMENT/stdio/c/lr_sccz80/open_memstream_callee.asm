
; FILE *open_memstream(char **bufp, size_t *sizep)

XDEF open_memstream_callee

open_memstream_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_open_memstream.asm"
