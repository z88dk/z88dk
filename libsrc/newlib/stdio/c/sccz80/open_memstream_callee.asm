
; FILE *open_memstream(char **bufp, size_t *sizep)

SECTION code_clib
SECTION code_stdio

PUBLIC open_memstream_callee

EXTERN asm_open_memstream

open_memstream_callee:

   pop af
   pop hl
   pop de
   push af

   push ix
   call asm_open_memstream
   pop ix
   ret
