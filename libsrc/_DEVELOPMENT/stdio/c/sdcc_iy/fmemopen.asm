
; FILE *fmemopen(void *buf, size_t size, const char *mode)

XDEF fmemopen

fmemopen:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_fmemopen.asm"
