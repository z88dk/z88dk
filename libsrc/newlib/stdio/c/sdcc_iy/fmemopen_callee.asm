
; FILE *fmemopen_callee(void *buf, size_t size, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fmemopen_callee

EXTERN asm_fmemopen

_fmemopen_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_fmemopen
