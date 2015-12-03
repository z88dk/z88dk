
; FILE *fmemopen(void *buf, size_t size, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC fmemopen_callee

EXTERN asm_fmemopen

fmemopen_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_fmemopen
