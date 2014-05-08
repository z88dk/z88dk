
; FILE *open_memstream(char **bufp, size_t *sizep)

PUBLIC _open_memstream

_open_memstream:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   push ix
   
   call asm_open_memstream
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_open_memstream.asm"
