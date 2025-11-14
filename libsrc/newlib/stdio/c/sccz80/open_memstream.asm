
; FILE *open_memstream(char **bufp, size_t *sizep)

SECTION code_clib
SECTION code_stdio

PUBLIC open_memstream

EXTERN asm_open_memstream

open_memstream:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_open_memstream
