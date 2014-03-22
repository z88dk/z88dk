
; FILE *fmemopen(void *buf, size_t size, const char *mode)

XDEF fmemopen

fmemopen:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   push ix
   
   call asm_fmemopen
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fmemopen.asm"
