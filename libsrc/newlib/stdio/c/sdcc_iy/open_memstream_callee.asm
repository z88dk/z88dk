
; FILE *open_memstream_callee(char **bufp, size_t *sizep)

SECTION code_clib
SECTION code_stdio

PUBLIC _open_memstream_callee

EXTERN asm_open_memstream

_open_memstream_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_open_memstream
