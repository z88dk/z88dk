
; FILE *fmemopen(void *buf, size_t size, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC fmemopen

EXTERN asm_fmemopen

fmemopen:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_fmemopen
