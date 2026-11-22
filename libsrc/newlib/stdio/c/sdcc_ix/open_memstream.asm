
; FILE *open_memstream(char **bufp, size_t *sizep)

SECTION code_clib
SECTION code_stdio

PUBLIC _open_memstream

EXTERN l0_open_memstream_callee

_open_memstream:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp l0_open_memstream_callee
