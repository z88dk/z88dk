
; FILE *open_memstream(char **bufp, size_t *sizep)

XDEF open_memstream

open_memstream:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push ix
   
   call asm_open_memstream
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_open_memstream.asm"
