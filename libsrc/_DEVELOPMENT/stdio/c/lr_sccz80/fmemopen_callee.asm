
; FILE *fmemopen(void *buf, size_t size, const char *mode)

XDEF fmemopen_callee

fmemopen_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_fmemopen.asm"
