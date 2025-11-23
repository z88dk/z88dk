
; FILE *fmemopen(void *buf, size_t size, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fmemopen

EXTERN asm_fmemopen

_fmemopen:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_fmemopen
